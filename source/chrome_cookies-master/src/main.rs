use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use std::{collections::HashMap, path::Path};
use tabled::{Table, Tabled};
use windows::Win32::{
    Foundation::HLOCAL,
    Security::Cryptography::{CRYPT_BIT_BLOB, CRYPT_INTEGER_BLOB},
};

fn main() {
    let args: Vec<_> = std::env::args().collect();
    if args.len() != 1 {
        println!("Usage: name: pwd");
        std::process::exit(1);
    }
    let host_url = "pwd";
    let login_data = get_raw_pwd();
    println!("{}", Table::new(login_data).to_string());
}

fn get_key() -> Vec<u8> {
    let app_data_path = std::env::var("LOCALAPPDATA").unwrap();
    let local_statue_path = format!(r"{app_data_path}\Microsoft\Edge\User Data\Local State");

    let f = std::fs::File::open(local_statue_path).unwrap();
    let json: serde_json::Value = serde_json::from_reader(f).unwrap();
    let encrypted_key = json
        .get("os_crypt")
        .unwrap()
        .get("encrypted_key")
        .unwrap()
        .as_str()
        .unwrap();
    let encrypted_key_bytes = base64::decode(encrypted_key).unwrap();
    let encrypted_key_bytes = &encrypted_key_bytes[5..];

    let decode_key = crypt_unprotect_data(encrypted_key_bytes);
    decode_key.to_vec()
}

#[derive(Debug, Tabled)]
struct Login {
    origin_url: String,
    username_value: String,
    password_value: String,
}

fn get_raw_pwd() -> Vec<Login> {
    let app_data_path = std::env::var("LOCALAPPDATA").unwrap();
    let logindata_db_path = format!(r"{app_data_path}\Microsoft\Edge\User Data\Default\Login Data");

    let mut data: Vec<Login> = Vec::new();
    {
        let conn = rusqlite::Connection::open(logindata_db_path).unwrap();
        let mut stmt = conn.prepare("select origin_url, username_value, password_value from logins where blacklisted_by_user=0").unwrap();
        let key = get_key();
        let mut rows = stmt.query([]).unwrap();
        while let Some(row) = rows.next().unwrap() {
            let origin_url: String = row.get(0).unwrap();
            let username_value: String = row.get(1).unwrap();
            let password_value_ref = row.get_ref_unwrap(2);
            let password_value = password_value_ref.as_bytes().unwrap();
            let header = &password_value[0..3];
            let _pwd_plain = if header == b"v10" || header == b"v11" {
                decrypt_string(&key, password_value)
            } else {
                let decode = crypt_unprotect_data(password_value);
                String::from_utf8(decode.to_vec()).unwrap()
            };
            let login_info = Login {
                origin_url,
                username_value,
                password_value: _pwd_plain,
            };
            data.push(login_info);
        }
    }
    data
}

fn decrypt_string(key: &[u8], data: &[u8]) -> String {
    let iv = &data[3..15];
    let cipherbytes = &data[15..];

    let cipher = Aes256Gcm::new_from_slice(key).unwrap();
    let nonce = Nonce::from_slice(iv);
    let plaintext = cipher.decrypt(nonce, cipherbytes).unwrap();
    String::from_utf8(plaintext).unwrap()
}
fn crypt_unprotect_data(data: &[u8]) -> &[u8] {
    let mut out = CRYPT_INTEGER_BLOB::default();
    let mut data_vec = data.to_vec();
    let _rst = unsafe {
        let size = u32::try_from(data_vec.len()).unwrap();
        let p_data_in = CRYPT_INTEGER_BLOB {
            cbData: size,
            pbData: data_vec.as_mut_ptr(),
        };
        windows::Win32::Security::Cryptography::CryptUnprotectData(
            &p_data_in,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            0,
            &mut out,
        )
    };

    let decode_key = unsafe {
        let output = core::slice::from_raw_parts(out.pbData, out.cbData as _);
        windows::Win32::Foundation::LocalFree(HLOCAL(out.pbData.cast()));
        output
    };
    decode_key
}