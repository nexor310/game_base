mkdir build
cd build
mkdir windows
mkdir linux
cd ..
godot --path .\project.godot --export "Windows" .\build\windows\game.exe
godot --path .\project.godot --export "Linux" .\build\linux\game.x86_64