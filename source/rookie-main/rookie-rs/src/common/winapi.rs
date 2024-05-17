use std::{ffi::c_void, ptr};

use anyhow::{anyhow, bail, Result};
use windows::{
    core::{HSTRING, PCWSTR, PWSTR},
    Win32::{
        Foundation,
        Foundation::{ERROR_MORE_DATA, ERROR_SUCCESS, WIN32_ERROR},
        Security::Cryptography,
        System::RestartManager::{
            RmEndSession, RmForceShutdown, RmGetList, RmRegisterResources, RmShutdown,
            RmStartSession, CCH_RM_SESSION_KEY, RM_PROCESS_INFO,
        },
    },
};

pub fn decrypt(keydpapi: &mut [u8]) -> Result<Vec<u8>> {
    // https://learn.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptunprotectdata
    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree
    // https://docs.rs/winapi/latest/winapi/um/dpapi/index.html
    // https://docs.rs/winapi/latest/winapi/um/winbase/fn.LocalFree.html

    let mut data_in = Cryptography::CRYPT_INTEGER_BLOB {
        cbData: keydpapi.len() as u32,
        pbData: keydpapi.as_mut_ptr(),
    };
    let mut data_out = Cryptography::CRYPT_INTEGER_BLOB {
        cbData: 0,
        pbData: ptr::null_mut(),
    };

    unsafe {
        let _ = match Cryptography::CryptUnprotectData(
            &mut data_in,
            Some(ptr::null_mut()),
            Some(ptr::null_mut()),
            Some(ptr::null_mut()),
            Some(ptr::null_mut()),
            0,
            &mut data_out,
        ) {
            Ok(_) => Ok(()),
            Err(_) => Err(anyhow!("CryptUnprotectData failed")),
        };
    }
    if data_out.pbData.is_null() {
        bail!("CryptUnprotectData returned a null pointer");
    }

    let decrypted_data =
        unsafe { std::slice::from_raw_parts(data_out.pbData, data_out.cbData as usize).to_vec() };
    let pbdata_hlocal = Foundation::HLOCAL(data_out.pbData as *mut c_void);
    unsafe {
        let _ = match Foundation::LocalFree(pbdata_hlocal) {
            Ok(_) => Ok(()),
            Err(_) => Err(anyhow!("LocalFree failed")),
        };
    };
    Ok(decrypted_data)
}

pub unsafe fn release_file_lock(file_path: &str) -> bool {
    let file_path = HSTRING::from(file_path);
    let mut session: u32 = 0;
    let mut session_key_buffer = [0_u16; (CCH_RM_SESSION_KEY as usize) + 1];
    let session_key = PWSTR(session_key_buffer.as_mut_ptr());
    let result = RmStartSession(&mut session, 0, session_key);
    if WIN32_ERROR(result) == ERROR_SUCCESS {
        let result = RmRegisterResources(session, Some(&[PCWSTR(file_path.as_ptr())]), None, None);
        if WIN32_ERROR(result) == ERROR_SUCCESS {
            let mut pnprocinfoneeded: u32 = 0;
            let mut rgaffectedapps: [RM_PROCESS_INFO; 1] = [RM_PROCESS_INFO {
                ..Default::default()
            }];
            let mut lpdwrebootreasons: u32 = 0;
            let mut pnprocinfo: u32 = 0;
            let result = RmGetList(
                session,
                &mut pnprocinfoneeded,
                &mut pnprocinfo,
                Some(rgaffectedapps.as_mut_ptr()),
                &mut lpdwrebootreasons,
            );
            if WIN32_ERROR(result) == ERROR_SUCCESS || WIN32_ERROR(result) == ERROR_MORE_DATA {
                if pnprocinfoneeded > 0 {
                    // If current process does not have enough privileges to close one of
                    // the "offending" processes, you'll get ERROR_FAIL_NOACTION_REBOOT
                    let result = RmShutdown(session, RmForceShutdown.0 as u32, None);
                    if WIN32_ERROR(result) == ERROR_SUCCESS {
                        // success
                        RmEndSession(session);
                        return true;
                    }
                } else {
                    // success
                    RmEndSession(session);
                    return true;
                }
            }
        }
        RmEndSession(session);
        return false;
    }
    return false;
}
