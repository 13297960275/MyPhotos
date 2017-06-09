using System;
using System.IO;
using System.Text;

namespace MyPhotos.Common
{
    public class FileLogger
    {
        public void LogException(Exception e)
        {
            File.AppendAllText(
                "E:/workspace/Csharp/ASPNET/MyPhotos/MyPhotos/Log/Logs.txt",
                "Exceptions:{" + "\r\n\t DateTime:" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\r\n\t Message:" + e.Message + "\r\n\t Stacktrace:" + e.StackTrace + "\r\n}\r\n\r\n"
            );
        }

        public void LogMessage(string msg)
        {
            File.AppendAllText(
                "E:/workspace/Csharp/ASPNET/MyPhotos/MyPhotos/Log/Logs.txt",
                "Messages:{" + "\r\n\t DateTime:" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\r\n\t Message:" + msg + "\r\n}\r\n\r\n"
            );
        }
    }
}