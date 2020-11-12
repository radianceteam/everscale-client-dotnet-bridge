# TON SDK building scripts

Just for building TON SDK client binaries from this repo: https://github.com/tonlabs/TON-SDK.

## Requirements

### All platforms

1. CMake version 3.9 or higher (https://cmake.org/download/).
2. Rust version 1.47.0 or higher (https://www.rust-lang.org/).

### Windows

#### Visual Studio 2019

https://visualstudio.microsoft.com/downloads/

## Build

### Versioning

Version of the library is the exact tag name in https://github.com/tonlabs/TON-SDK repository.
When building, it pulls the TON-SDK sources using the specified tag name.

### Running build

Native binaries are built and placed into `install` directory. 
The following sections describe build procedure for each platform.

#### Windows

##### x64

1. Open `x86_x64 Cross Tools Command Prompt for VS 2019`
2. Run `build.bat x64 <TON SDK VERSION>`

##### x86

1. Open `x86 Cross Tools Command Prompt for VS 2019`
2. Run `build.bat x86 <TON SDK VERSION>`

#### Linux/MacOS

```
./build.sh <TON SDK VERSION>
```

## Deployment

```
git tag <TAG>
git push origin <TAG>
```

for example

```
git tag 1.1.0
git push origin 1.1.0
```

This will trigger GitHub build automatically, then you could download platform-specific 
binaries from build artifacts here https://github.com/radianceteam/ton-client-dotnet-bridge/actions.
