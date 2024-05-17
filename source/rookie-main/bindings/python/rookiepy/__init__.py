from sys import platform
from typing import Any, Dict, List, Optional
import http.cookiejar
from .rookiepy import (
    firefox,
    firefox_based,
    brave, 
    edge, 
    chrome, 
    chromium_based, 
    chromium, 
    opera, 
    vivaldi,
    opera_gx,
    librewolf,
    load,
    any_browser
)

__all__ = [
    "firefox",
    "librewolf",
    "brave",
    "edge",
    "chrome",
    "chromium",
    "opera",
    "opera_gx",
    "vivaldi",
    "chromium_based",
    "firefox_based",
    "to_dict", # type: ignore
    "to_cookiejar",
    "create_cookie",
    "load",
    "any_browser"
]


CookieList = List[Dict[str, Any]]


# Windows
if platform == "win32":
    from .rookiepy import internet_explorer, octo_browser
    __all__.extend([
        "internet_explorer",
        "octo_browser"
    ])

# macOS
if platform == "darwin":
    from .rookiepy import safari
    __all__.extend([
        "safari"
    ])


def create_cookie(
        host: str,
        path: str,
        secure: bool,
        expires: Optional[int],
        name: str,
        value: Optional[str],
        http_only: bool,
        ) -> http.cookiejar.Cookie:
    """
    Create a Cookie object with the specified attributes.

    :param str host: The domain for which the cookie is valid
    :param str path: The path within the domain for which the cookie is valid
    :param bool secure: True if the cookie should only be sent over secure connections (HTTPS)
    :param Optional[int] expires: Unix timestamp indicating when the cookie expires
    :param str name: The name of the cookie
    :param Optional[str] value: The value of the cookie
    :param bool http_only: True if the cookie should only be accessible via HTTP and not JavaScript
    :return: A Cookie object
    :rtype: http.cookiejar.Cookie
    """
    # HTTPOnly flag goes in _rest, if present (see https://github.com/python/cpython/pull/17471/files#r511187060)
    return http.cookiejar.Cookie(version=0,
                                 name=name,
                                 value=value,
                                 port=None,
                                 port_specified=False,
                                 domain=host,
                                 domain_specified=host.startswith('.'),
                                 domain_initial_dot=host.startswith('.'),
                                 path=path,
                                 path_specified=True,
                                 secure=secure,
                                 expires=expires,
                                 discard=False,
                                 comment=None,
                                 comment_url=None,
                                 rest={'HTTPOnly': ''} if http_only else {}
                                 )

def to_cookiejar(cookies: CookieList) -> http.cookiejar.CookieJar:
    """
    Convert a list of dictionaries representing cookies to a CookieJar.

    :param cookies: A list of dictionaries representing cookies
    :return: A CookieJar containing the converted cookies
    """
    cj = http.cookiejar.CookieJar()
    
    for cookie_obj in cookies:
        c = create_cookie(
            cookie_obj['domain'],
            cookie_obj['path'],
            cookie_obj['secure'],
            cookie_obj['expires'],
            cookie_obj['name'],
            cookie_obj['value'],
            cookie_obj['http_only'],

        )
        cj.set_cookie(c)
    return cj


