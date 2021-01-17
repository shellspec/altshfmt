# AltSH formatter (experimental)

The **`altshfmt`** is an experimental tool for formatting AltSH (alternative shell script) with extended syntax that cannot be formatted correctly by [shfmt][shfmt]. This is implemented as a wrapper for `shfmt`.

**Currently supported syntax**: [ShellSpec][shellspec], [shpec](shpec)

[altshfmt-releases]: https://github.com/shellspec/altshfmt/releases
[shfmt]: https://github.com/mvdan/sh#shfmt
[shfmt-releases]: https://github.com/mvdan/sh/releases
[busybox-w32]: https://frippery.org/busybox
[shellspec]: https://github.com/shellspec/shellspec
[shpec]: https://github.com/rylnd/shpec
[shell-format]: https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format

## **Use it at your own risk**

* It has not been enough tested. Please make sure to save and version control your files properly so that they can be restored even if they are corrupted.
* It depends on the behavior of `shfmt`, so it may not work depending on the combination of versions.
* Incompatible changes may be made.

## Requirements

* [shfmt][shfmt-releases] v3.2.1
* Basic commands (`awk`, `cat`, `cmp`, `cp`, `diff`, `grep`, `ls`, `mktemp`, `rm`, `sed`, `which`)

## How to use

Since `altshfmt` is implemented as compatible as possible with `shfmt`, You can use it instead of the `shfmt` command.

### Linux or macOS

* Download `altshfmt` archive from [here][altshfmt-releases] and extract it to a directory, or use `git clone`.
* Download `shfmt` binary from [here][shfmt-releases] and save it in the directory where `altshfmt` is located.

### Windows

WSL (Windows 10, version 1803 and later) or [busybox-w32][busybox-w32] is required. To run it from Windows (instead of from WSL), run `altshfmt.bat` instead of `altshfmt`.

#### WSL

* Download `altshfmt` archive from [here][altshfmt-releases] and extract it to a directory, or use `git clone`.
* Download `shfmt` binary from [here][shfmt-releases] and save it in the directory where `altshfmt` is located.
* The `shfmt` binary can be used for Windows or Linux.

#### busybox-w32

* Download `altshfmt` archive from [here][altshfmt-releases] and extract it to a directory, or use `git clone`.
* Download `shfmt` binary from [here][shfmt-releases] and save it in the directory where `altshfmt` is located.
* Download `busybox` binary from [here][busybox-w32], rename it to `bash.exe` and save it in the directory where `altshfmt` is located.

### Using with VSCode

Use the [shell-format][shell-format] extension.

* Install the shell-format extension and change `shellformat.path` in `settings.json` to the path to the `altshfmt` (or `altshfmt.bat` for windows).

## About syntax detection

The syntax is **automatically determined** from the beginning and ending pairs of the block of DSL used in the shell script.

### shell directive

If you have problems with the automatic detection, you can also use the shell directive. The shell directive is a comment that begins with "`shell:`".

Example

```sh
#!/bin/sh
# shell: sh altsh=shellspec

Describe
  ...
End
```

Usage: `shell: [<shell>] [altsh=<syntax>]`

* `shell`: `sh`, `bash`, `mksh`
  * Unspecified: same as `auto`
  * It is treated as the value of the `-ln` flag of the `shfmt` command
    * `auto`: do not specify the `-ln` flag
    * `sh`: implies `-ln posix`
    * `bash`: implies `-ln bash`
    * `mksh`: implies `-ln mksh`
    * Others: implies `-ln bash`
* `syntax`: `shellspec`, `shpec`
  * Unspecified: Treat it as a pure shell script
  * Others: Treat it as a pure shell script

## Limitation

`altshfmt` is several times slower than `shfmt`.
