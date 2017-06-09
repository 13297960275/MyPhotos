using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MyPhotos.Common
{
    public class MD5Helper
    {
        /// <summary>
        /// 字符串MD5加密
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public string EncryptString(string str)
        {
            using (MD5 md5String = MD5.Create())
            {
                StringBuilder sb = new StringBuilder();
                byte[] bytes = Encoding.UTF8.GetBytes(str);
                byte[] md5Encrypt = md5String.ComputeHash(bytes);
                for (int i = 0; i < md5Encrypt.Length; i++)
                {
                    sb.Append(md5Encrypt[i].ToString("x2"));
                }
                return sb.ToString();
            }
        }
        /// <summary>
        /// 文件加密
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public string EncryptFile(string path)
        {
            using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (MD5 md5Encrypt = MD5.Create())
                {
                    byte[] encryptBytes = md5Encrypt.ComputeHash(fs);
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < encryptBytes.Length; i++)
                    {
                        sb.Append(encryptBytes[i].ToString("x2"));
                    }
                    return sb.ToString();
                }
            }
        }

        /// <summary>
        /// 计算文件的MD5值
        /// </summary>
        /// <param name="filepath"></param>
        /// <returns></returns>
        public String GetStreamMD5(Stream stream)
        {
            string strResult = "";
            string strHashData = "";
            byte[] arrbytHashValue;
            MD5CryptoServiceProvider oMD5Hasher = new MD5CryptoServiceProvider();
            arrbytHashValue = oMD5Hasher.ComputeHash(stream); //计算指定Stream 对象的哈希值
            //由以连字符分隔的十六进制对构成的String，其中每一对表示value 中对应的元素；例如“F-2C-4A”
            strHashData = System.BitConverter.ToString(arrbytHashValue);
            //替换-
            strHashData = strHashData.Replace("-", "");
            strResult = strHashData;
            return strResult;
        }

        public string GetMD5HashFromFile(string fileName)
        {
            try
            {
                FileStream file = new FileStream(fileName, FileMode.Open);
                MD5 md5 = new MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(file);
                file.Close();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < retVal.Length; i++)
                {
                    sb.Append(retVal[i].ToString());
                }
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("GetMD5HashFromFile() fail, error:" + ex.Message);
            }
        }

        public string GetMD5WithFilePath(string filePath)
        {
            FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] hash_byte = md5.ComputeHash(file);
            string str = BitConverter.ToString(hash_byte);
            //str = str.Replace("-", "");
            return str;
        }
    }
}
