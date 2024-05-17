# rookie

[![PyPi Downloads][PyPi-downloads]][PyPi-url]
[![PyPi Version][PyPi-version]][PyPi-url]
[![Crates][Crates-badge]][Crates-url]
[![License][License-shield]][License-url]

Load cookies from any browser on any platform

## Install ⚙️

```shell
cargo add rookie
```

## Bindings 📚

There's Python bindings to `rookie`

```shell
pip install rookiepy
```

And the usage it similar to original

```python
import rookiepy
cookies = rookiepy.firefox(["google.com"])
for cookie in cookies:
    print(cookie['domain'], cookie['value'])
```

## Examples 📋

`Python` [examples](https://github.com/thewh1teagle/rookie/tree/main/examples)

`Rust` [rookie-rs/examples](https://github.com/thewh1teagle/rookie/tree/main/rookie-rs/examples)

## Docs 📘

`Python`

- [docs/Python.md](docs/Python.md)

`Rust`

- [docs/Rust.md](docs/Rust.md)
- [docs.rs/rookie](https://docs.rs/rookie)  

## Features 🚀

- Fast, written in `Rust`
- Bypass `Chrome` restriction like file locking
- Wide platforms and browsers support

## CLI 💻

You can use rookie as a `CLI` tool which will decrypt the cookies and print it as `JSON`  
See [cli](https://github.com/thewh1teagle/rookie/tree/main/cli) folder

## Contribute 🤝

So far the following platforms are supported:

- **Chrome:** `Linux`, `macOS`, `Windows`
- **Firefox:** `Linux`, `macOS`, `Windows`
- **LibreWolf:** `Linux`, `macOS`, `Windows`
- **Cachy:** `Linux`
- **Opera:** `Linux`, `macOS`, `Windows`
- **Opera GX:** `macOS`, `Windows`
- **Edge:** `Linux`, `macOS`, `Windows`
- **Internet Explorer:** `Windows`
- **Chromium:** `Linux`, `macOS`, `Windows`
- **Brave:** `Linux`, `macOS`, `Windows`
- **Vivaldi:** `Linux`, `macOS`, `Windows`
- **Safari:** `macOS`

You are welcome to contribute support for other browsers, or other platforms.

## Support new browsers 🌐

If you have a browser with which the library isn't working with, it may not have been added to the list of supported browsers configs. You can create a pull request (PR) or an issue with the path to the cookies file on your computer, and I will add it.

look at [config.rs](https://github.com/thewh1teagle/rookie/blob/main/rookie-rs/src/config.rs) to see what configurations is needed.

## Testing Dates  (DD/MM/YY) 📅

| Browser   |  Linux   |  macOS   | Windows  |
|:----------|:--------:|:--------:|:--------:|
| Chrome    | 01/10/23 | 25/11/23 | 16/03/24 |
| Firefox   | 01/10/23 | 25/11/23 | 16/03/24 |
| LibreWolf | 01/10/23 | 25/11/23 | 01/10/23 |
| Cachy     | 04/06/24 |   N/A    |   N/A    |
| Opera     | 01/10/23 |    -     | 01/10/23 |
| Opera GX  |   N/A    |    -     | 01/10/23 |
| Edge      | 01/10/23 |    -     | 01/10/23 |
| IE        |   N/A    |   N/A    | 01/10/23 |
| Chromium  | 01/10/23 | 25/11/23 | 01/10/23 |
| Brave     | 01/10/23 | 25/11/23 | 01/10/23 |
| Vivaldi   | 01/10/23 | 25/11/23 | 01/10/23 |
| Safari    |   N/A    | 02/10/23 |   N/A    |

## Credits 🙌
[github.com/borisbabic/browser_cookie3](https://github.com/borisbabic/browser_cookie3)

[PyPi-downloads]: https://img.shields.io/pypi/dm/rookiepy
[PyPi-version]: https://img.shields.io/pypi/v/rookiepy?color=00aa00
[PyPi-url]: https://pypi.org/project/rookiepy/
[Crates-badge]: https://img.shields.io/crates/v/rookie
[Crates-url]: https://crates.io/crates/rookie/
[License-shield]: https://img.shields.io/github/license/thewh1teagle/rookie?color=00aaaa
[License-url]: https://github.com/thewh1teagle/rookie/blob/main/rookie-rs/MIT-LICENSE.txt
