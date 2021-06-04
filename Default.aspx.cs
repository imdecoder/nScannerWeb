using System;
using System.Drawing;
using System.IO;
using System.Web.Services;
using ZXing;

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
            string base64 = imageSrc.Replace("data:image/png;base64,", "");

            //SaveByteArrayAsImage(@"C:/nScanner/output.png", base64);

            Bitmap bmp = Base64StringToBitmap(base64);
            BarcodeReader reader = new BarcodeReader();

            try
            {
                Result result = reader.Decode(bmp);

                if (result == null)
                {
                    return "error";
                }

                return result.Text;
            }
            catch (Exception)
            {
                return "error";
            }
        }

        public static Bitmap Base64StringToBitmap(string base64String)
        {
            Bitmap bmpReturn = null;

            byte[] byteBuffer = Convert.FromBase64String(base64String);
            MemoryStream memoryStream = new MemoryStream(byteBuffer);

            memoryStream.Position = 0;

            bmpReturn = (Bitmap)Bitmap.FromStream(memoryStream);

            memoryStream.Close();
            memoryStream = null;
            byteBuffer = null;

            return bmpReturn;
        }

        private static void SaveByteArrayAsImage(string fullOutputPath, string base64String)
        {
            byte[] bytes = Convert.FromBase64String(base64String);

            Image image;
            
            using (MemoryStream ms = new MemoryStream(bytes))
            {
                image = Image.FromStream(ms);
            }

            image.Save(fullOutputPath, System.Drawing.Imaging.ImageFormat.Png);
        }
    }
}