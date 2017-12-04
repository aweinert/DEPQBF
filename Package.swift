import PackageDescription

let package = Package(
    name: "DEPQBF",
    dependencies: [
        .Package(url: "https://github.com/aweinert/CDEPQBF.git", majorVersion: 1)
    ]
)
