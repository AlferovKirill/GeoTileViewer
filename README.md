# GeoTileViewer

## Description

The application is a windowed Qt application for Linux that downloads and displays a section of a satellite image from a public map server at user-defined coordinates and zoom level.

## Functional

- User data input: latitude (lat), longitude (lon), zoom;
- Loading and displaying the corresponding section of the satellite map;
- Displaying coordinates under the mouse cursor in the window title in two coordinate systems: WGS84 and UTM;
- Support for Linux.

## Requirements

- Qt 6.5 or later;
- `qtkeychain-qt6-dev`;
- `libgeographiclib-dev`;
- Internet connection for downloading maps;
- Compilation and execution on Linux.

Also this project has a submodule `google_maps` that provides a plugin for Google Maps. This dependency is located in the external folder, and you can read more about it there. Also, keep in mind that you will need your own API key for Google Maps. You can set it using environment variables, as shown in the example below.

## Tips

- Install Qt of the required version (>= 6.5) using the official Qt installer;
- Install some other libraries from the official package manager, like this:

``` bash
sudo apt install qtkeychain-qt6-dev
sudo apt install libgeographiclib-dev
```

- For the `libgeographiclib-dev` library, you may need to add a symbolic link to another folder. Find out the CMake version first and then make a symbolic link to the specific version;

``` bash
cmake --version
sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-3.XX/Modules/
```

- Pass the environment variables in a way that is convenient for you. For example, add the following to the end of the ~/.bashrc file and reboot after.

``` bash
export LD_LIBRARY_PATH=~/Qt/6.5.3/gcc_64/lib:$LD_LIBRARY_PATH
export MAPS_ACCESS_TOKEN=some_very_secret_token
```

## Demonstration

<img width="3066" height="1854" alt="Image" src="https://github.com/user-attachments/assets/a7e8862d-ff5f-4649-ac68-77f06dbe6ef1" />
<img width="3066" height="1854" alt="Image" src="https://github.com/user-attachments/assets/8f242e5c-d367-4f4e-9398-d75d43f8fa4b" />

[https://github.com/user-attachments/assets/0f4934ea-cd8b-484e-a906-b84fc2ea4556](https://github.com/user-attachments/assets/0f4934ea-cd8b-484e-a906-b84fc2ea4556)

# Building and installing

See the [BUILDING](BUILDING.md) document.

# Contributing

See the [CONTRIBUTING](CONTRIBUTING.md) document.

# Licensing

See the [LICENSE](LICENSE) document.
