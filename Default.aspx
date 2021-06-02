<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="nScanner.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>nScanner</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="video-wrap">
        <video id="video" playsinline autoplay></video>
    </div>
    <div class="controller">
        <button id="snap">
            Capture
        </button>
        <button id="decode">
            Decode
        </button>
    </div>
    <canvas id="canvas" width="200" height="200"></canvas>
    <image id="image"></image>

    <script>
        'use strict';

        const video = document.getElementById('video');
        const canvas = document.getElementById('canvas');
        const image = document.getElementById('image');
        const snap = document.getElementById('snap');
        const decode = document.getElementById('decode');
        const errorMsg = document.getElementById('errorMsg');

        const constraints = {
            video: {
                width: 200,
                height: 200
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
            context.drawImage(video, 0, 0, 200, 200);
        });

        decode.addEventListener('click', function () {
            image.src = canvas.toDataURL();

            var imageSrc = image.src;

            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                url: 'Default.aspx/ImageDecoder',
                data: '{imageSrc: "' + imageSrc + '" }',
                success: function (result) {
                    alert(result.d);
                },
                error: function (xhr, status, error) {
                    alert(xhr.responseText);
                    //alert('Hata! Sunucuya ulaşılamıyor.');
                }
            });
        });
    </script>
</body>
</html>
