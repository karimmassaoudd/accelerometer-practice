# Accelerometer practice

This is a small proof of concept for learning how a smartphone accelerometer can send motion data to a webpage. It is not the final Driving Behavior Monitor app.

## Implementation plan

1. Make one plain HTML page with three boxes for X, Y, and Z.
2. Wait for the user to press **Start sensor**.
3. Ask for motion permission when the browser requires it.
4. Listen for the browser's `devicemotion` event.
5. Read `accelerationIncludingGravity` and show each value in metres per second squared (`m/s²`).
6. Stop listening when **Stop sensor** is pressed.

Keeping everything in `index.html` makes this first experiment easy to inspect and explain. No library, database, server code, or framework is needed.

## What X, Y, and Z mean

The values describe acceleration along three directions fixed to the phone:

- **X:** left to right across the screen.
- **Y:** bottom to top along the screen.
- **Z:** out of and into the screen.

The sign (+ or -) changes when the phone faces the opposite direction. Exact signs can feel confusing at first because they depend on the phone's orientation. Tilt the phone slowly and observe which value changes; this is the best way to learn its axes on your own device.

`accelerationIncludingGravity` includes Earth's gravity, about `9.81 m/s²`. For example, when the phone is still and flat, one axis will normally be close to either `9.81` or `-9.81`. When you accelerate the phone, the values change as well.

## Important JavaScript, in simple English

`window.addEventListener("devicemotion", handleMotion)` tells the browser: “when the phone has new motion information, call `handleMotion`.” The phone's operating system gives the browser sensor readings, and the browser creates a `devicemotion` event for the webpage. The page therefore receives updates while it is open; it does not read the sensor directly.

Inside `handleMotion`, this line gets the data needed for this experiment:

```js
const acceleration = event.accelerationIncludingGravity;
```

`acceleration.x`, `.y`, and `.z` are then put into the three boxes. `toFixed(2)` limits each displayed number to two decimal places so it is easier to read. The values are still measured in `m/s²`.

`DeviceMotionEvent.requestPermission` exists in some browsers. If it exists, the code asks the user before starting. Android Chrome commonly does not need this explicit request, but supporting it makes the page clearer and more compatible.

`window.removeEventListener("devicemotion", handleMotion)` stops updates. Removing the exact same `handleMotion` function is important: it is the listener that was previously added.

## Test on your Android phone

1. Publish the page with HTTPS using one of the options below.
2. On the phone, open the HTTPS address in Chrome.
3. Press **Start sensor** and allow motion/sensor permission if Chrome asks.
4. Keep the page in the foreground and tilt or move the phone.
5. Press **Stop sensor**. The values should stop changing.

Do not judge it only by opening `index.html` directly from your phone's file manager. Browser sensor APIs normally need a secure context, which means HTTPS (or `localhost` during local development).

## Publish with HTTPS

The simplest free option is GitHub Pages:

1. Create a new GitHub repository and upload `index.html` and `readme.md`.
2. In the repository, open **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**, select your main branch and the root folder, then save.
4. GitHub gives you an `https://...github.io/...` address. Open that address on your Android phone.

GitHub Pages provides HTTPS. If you use another host, confirm that its final address starts with `https://`, not `http://`.

## Common errors and fixes

| What you see | Likely cause | What to try |
| --- | --- | --- |
| Values stay `--` | The sensor has not been started or the page has no sensor data. | Press Start, keep the page visible, then move the phone. |
| “does not support the Device Motion API” | The browser/device does not expose this API. | Try current Chrome on a real Android phone. |
| No values when opening a local file or HTTP site | Motion APIs may require a secure context. | Use the HTTPS GitHub Pages address. |
| “Motion permission was not granted” | Permission was denied. | Reload, press Start again, and allow the permission. Check browser site permissions if needed. |
| Values do not match an expected axis | Phone orientation and axis signs differ from your expectation. | Hold the phone still, then tilt one direction at a time and record which axis changes. |
| Values seem noisy | Sensors are physical hardware and have small measurement variation. | Look for overall movement, not perfectly stable decimals. |

## Technical decision summary

The `devicemotion` API was chosen because it is a browser API for motion sensor updates. `accelerationIncludingGravity` was chosen specifically for this exercise because it exposes the gravity component and makes tilting the phone easy to observe. This is a good first hardware experiment before deciding what calculations a future driving-behaviour app needs.
