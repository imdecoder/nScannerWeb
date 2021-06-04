<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="nScanner.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>nScanner</title>

    <style>
        body {
            margin: 0;
        }

        #video {
            position: fixed;
            min-width: 100%;
            min-height: 100%;
        }

        #canvas {
            display: none;
        }

        .controller {
            position: fixed;
            bottom: 50px;
            left: 0;
            right: 0;
            width: 120px;
            margin: 0 auto;
            text-align: center;
        }

        .controller button {
            min-width: 120px;
            min-height: 120px;
            background: linear-gradient(to right, rgb(233, 100, 67), rgb(144, 78, 149));
            color: #fff;
            font-size: 21px;
            font-weight: bold;
            letter-spacing: 3px;
            text-transform: uppercase;
            border: none;
            border-radius: 50%;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3), 0 0 40px rgba(0, 0, 0, 0.1) inset;
            outline: none;
            cursor: pointer;
        }

        .ncode {
            position: fixed;
            top: 50px;
            right: 50px;
        }

        .ncode img {
            width: 130px;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <video id="video" playsinline autoplay></video>
    <canvas id="canvas" width="700" height="500"></canvas>
    <div class="controller">
        <button id="snap">
            Oku
        </button>
    </div>
    <div class="ncode">
        <img src="Content/ncode.png" alt="nCode" />
    </div>

    <script>
        'use strict';

        const video = document.getElementById('video');
        const canvas = document.getElementById('canvas');
        const snap = document.getElementById('snap');
        const errorMsg = document.getElementById('errorMsg');

        const constraints = {
            video: {
                width: 700,
                height: 500,
                facingMode: 'environment'
            }
        }

        async function init() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia(constraints);
                handleSuccess(stream);
            }
            catch (e) {
                errorMsg.innerHTML = `navigator.getUserMedia.error: ${e.toString()}`;
            }
        }

        function handleSuccess(stream) {
            window.stream = stream;
            video.srcObject = stream;
        }

        init();

        var context = canvas.getContext('2d');

        snap.addEventListener('click', function () {
            scan();
        });

        setInterval(function () {
            scan();
        }, 2000);

        function scan() {
            context.drawImage(video, 0, 0, 700, 500);

            var imageSrc = canvas.toDataURL();

            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                url: 'Default.aspx/ImageDecoder',
                data: '{imageSrc: "' + imageSrc + '" }',
                success: function (result) {
                    if (result.d != 'error') {
                        alert(result.d);
                    }
                },
                error: function (xhr, status, error) {
                    alert(xhr.responseText);
                }
            });
        }
    </script>
</body>
</html>
