#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/hakan-taspinar/catkin_ws/src/DynamixelSDK/ros/dynamixel_sdk"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/hakan-taspinar/catkin_ws/install/lib/python3/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/hakan-taspinar/catkin_ws/install/lib/python3/dist-packages:/home/hakan-taspinar/catkin_ws/build/lib/python3/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/hakan-taspinar/catkin_ws/build" \
    "/home/hakan-taspinar/anaconda3/bin/python3" \
    "/home/hakan-taspinar/catkin_ws/src/DynamixelSDK/ros/dynamixel_sdk/setup.py" \
     \
    build --build-base "/home/hakan-taspinar/catkin_ws/build/DynamixelSDK/ros/dynamixel_sdk" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/hakan-taspinar/catkin_ws/install" --install-scripts="/home/hakan-taspinar/catkin_ws/install/bin"
