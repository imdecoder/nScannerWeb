using ZXing;
using OpenCvSharp;
using System;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.Services;
using ZXing.Common;
using OpenCvSharp.CPlusPlus;
using OpenCvSharp.Extensions;
using System.Collections.Generic;

namespace nScanner
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string ImageDecoder(string imageSrc)
        {
            string imageURL = imageSrc.Replace("data:image/png;base64,", "");

            Bitmap bmpFromString = Base64StringToBitmap(imageURL);
            var barcodeBitmap = new Bitmap(bmpFromString);

            var source = new BitmapLuminanceSource(barcodeBitmap);

            // using http://zxingnet.codeplex.com/
            // PM> Install-Package ZXing.Net
            var reader = new BarcodeReader(null, null, ls => new GlobalHistogramBinarizer(ls))
            {
                AutoRotate = true,
                TryInverted = true,
                Options = new DecodingOptions
                {
                    TryHarder = true,
                    PureBarcode = true,
                    PossibleFormats = new List<BarcodeFormat>
                    {
                        BarcodeFormat.CODE_128,
                        BarcodeFormat.EAN_8,
                        BarcodeFormat.CODE_39,
                        BarcodeFormat.UPC_A
                    }
                }
            };

            var newhint = new KeyValuePair<DecodeHintType, object>(DecodeHintType.ALLOWED_EAN_EXTENSIONS, new Object());
            reader.Options.Hints.Add(newhint);

            var result = reader.Decode(source);
            if (result == null)
            {
                return string.Empty;
            }

            var writer = new BarcodeWriter
            {
                Format = result.BarcodeFormat,
                Options = { Width = 200, Height = 50, Margin = 4 },
                Renderer = new ZXing.Rendering.BitmapRenderer()
            };
            
            var barcodeImage = writer.Write(result.Text);
            Cv2.ImShow("BarcodeWriter", barcodeImage.ToMat());

            return result.Text;
        }

        public static Bitmap Base64StringToBitmap(string base64String)
        {
            Bitmap bmpReturn = null;

            //Convert Base64 string to byte[]
            byte[] byteBuffer = Convert.FromBase64String(base64String);

            MemoryStream memoryStream = new MemoryStream(byteBuffer);

            memoryStream.Position = 0;

            bmpReturn = (Bitmap)Image.FromStream(memoryStream);

            memoryStream.Close();
            memoryStream = null;
            byteBuffer = null;

            return bmpReturn;
        }
    }
}