
using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.IO;
using System.Net;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Web;
using System.Collections;
namespace CCNF.Plugin.Upload
{
    /// <summary> 
    /// 上传功能。 
    /// 本类提供上传的一般性方法。 
    /// </summary> 
    /// <creator>Marc</creator> 
    public abstract class UploadAbstract : IUpload
    {
        #region 常量属性 
        /// <summary> 
        /// 允许上传的文件扩展名。 
        /// 多个文件扩展名以英文逗号隔开。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        private readonly string UPLOADEXTENTION = ConfigurationManager.AppSettings["UploadExtention"];
        private string uploadExtention = null;
        /// <summary> 
        /// 允许上传的文件扩展名。 
        /// 多个文件扩展名以英文逗号隔开。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        public string UploadExtention
        {
            get
            {
                if (string.IsNullOrEmpty(this.uploadExtention))
                {
                    if (string.IsNullOrEmpty(UPLOADEXTENTION))
                    {
                        throw new Exception("web.config中未配置UploadExtention属性");
                    }
                    this.uploadExtention = UPLOADEXTENTION;
                }
                return this.uploadExtention;
            }
            set
            {
                this.uploadExtention = value;
            }
        }
        /// <summary> 
        /// 允许上传的单个文件最大大小。 
        /// 单位为k。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        private readonly int UPLOADLENGTH = Convert.ToInt16(ConfigurationManager.AppSettings["UploadLength"]);
        private int uploadLength = 0;
        /// <summary> 
        /// 允许上传的单个文件最大大小。 
        /// 单位为。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        public int UploadLength
        {
            get
            {
                if (this.uploadLength == 0)
                {
                    this.uploadLength = UPLOADLENGTH;
                }
                return this.uploadLength;
            }
            set
            {
                this.uploadLength = value;
            }
        }
        /// <summary> 
        /// 所上传的文件要保存到哪个物理盘上。 
        /// 此值为严格的物理文件夹路径。如：E:\CCNF\ 
        /// 注意：必须有盘符。 
        /// 此属于用于扩展图片服务器数据存储。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        private readonly string UPLOADPHYSICALPATH = ConfigurationManager.AppSettings["UploadPhysicalPath"];
        private string uploadPhysicalPath = null;
        /// <summary> 
        /// 所上传的文件要保存到哪个物理盘上。 
        /// 此值为严格的物理文件夹路径。如：E:\CCNF\ 
        /// 注意：必须有盘符。 
        /// 此属性用于扩展图片服务器数据存储。 
        /// 默认从Web.config中获取。 
        /// </summary> 
        public string UploadPhysicalPath
        {
            get
            {
                if (string.IsNullOrEmpty(this.uploadPhysicalPath))
                {
                    if (string.IsNullOrEmpty(UPLOADPHYSICALPATH))
                    {
                        throw new Exception("web.config中未配置UploadPhysicalPath属性");
                    }
                    this.uploadPhysicalPath = UPLOADPHYSICALPATH;
                }
                return this.uploadPhysicalPath;
            }
            set
            {
                this.uploadPhysicalPath = value;
            }
        }
        #endregion
        #region 枚举 
        /// <summary> 
        /// 水印类型 
        /// </summary> 
        public enum WatermarkTypeEnum
        {
            /// <summary> 
            /// 文字水印 
            /// </summary> 
            String = 1,
            /// <summary> 
            /// 图片水印 
            /// </summary> 
            Image = 2
        }
        /// <summary> 
        /// 上传结果 
        /// </summary> 
        protected enum UploadResultEnum
        {
            /// <summary> 
            /// 未指定要上传的对象 
            /// </summary> 
            UploadedObjectIsNull = -9,
            /// <summary> 
            /// 文件扩展名不允许 
            /// </summary> 
            ExtentionIsNotAllowed = -2,
            /// <summary> 
            /// 文件大小不在限定范围内 
            /// </summary> 
            ContentLengthNotWithinTheScope = -1,
            /// <summary> 
            /// 未配置或未指定文件的物理保存路径 
            /// </summary> 
            UploadPhysicalPathNoSpecify = -20,
            /// <summary> 
            /// 未指定图片水印的相对文件物理路径 
            /// </summary> 
            ImageWartermarkPathNoSpecify = -30,
            /// <summary> 
            /// 未指定水印的文字 
            /// </summary> 
            StringWatermarkNoSpecify = -31,
            /// <summary> 
            /// 上传原始文件失败 
            /// </summary> 
            UploadOriginalFileFailure = 0,
            /// <summary> 
            /// 生成缩略失败 
            /// </summary> 
            CreateThumbnailImageFailure = -3,
            /// <summary> 
            /// 未知错误 
            /// </summary> 
            UnknownError = -4,
            /// <summary> 
            /// 上传成功 
            /// </summary> 
            Success = 1
        }
        #endregion
        #region 上传属性 
        /// <summary> 
        /// 保存文件夹。 
        /// 格式形如： upload\ 或 images\ 或 upload\user\ 等。以\结尾。 
        /// 不允许加盘符 
        /// </summary> 
        public string SaveFolder { get; set; }
        /// <summary> 
        /// 自定义生成新的文件夹。 
        /// 格式形如： upload\ 或 images\ 或 upload\2011\10\8\ 等。以\结尾。 
        /// 最终的文件夹 = UploadPhysicalPath + SaveFolder + Folder 
        /// </summary> 
        public string Folder { get; set; }
        /// <summary> 
        /// 是否生成水印。 
        /// 默认不启用水印生成。 
        /// </summary> 
        public bool IsMakeWatermark { get; set; }
        private int watermarkType = (int)WatermarkTypeEnum.String;
        /// <summary> 
        /// 生成水印的方式：string从文字生成，image从图片生成。 
        /// 默认是文字水印 
        /// </summary> 
        public int WatermarkType
        {
            get
            {
                return this.watermarkType;
            }
            set
            {
                this.watermarkType = value;
            }
        }
        /// <summary> 
        /// 水印文字。 
        /// </summary> 
        public string Watermark { get; set; }
        /// <summary> 
        /// 水印图片的位置。 
        /// 提供图片水印的相对位置。 
        /// 不含盘符。 
        /// </summary> 
        public string ImageWartermarkPath { get; set; }
        /// <summary> 
        /// 上传后生成的新文件路径。 
        /// 此路径为相对物理路径，不含盘符。 
        /// </summary> 
        public string NewFilePath { get; protected set; }
        /// <summary> 
        /// 生成缩略图片的长宽， 是一个二维数据。　 
        /// 如：int a[3,2]={{1,2},{5,6},{9,10}}。 
        /// 如果上传的文件是图片类型，并且希望生成此图片的缩略图，那么请将需要生成的长宽尺寸以数组的方式保存到这里。 
        /// </summary> 
        public int[,] PicSize { get; set; }
        /// <summary> 
        /// 生成的图片地址，与二维数组PicSize的长度是对应的。 
        /// 如果有传入PicSize的数组，那么上传完毕后，系统会返回PicPath数组。 
        /// 这个数组是它的最终上传路径，以便用户对此值进行数据库操作。 
        /// 产生的PicPath的索引位置与PicSize是一一对应的。 
        /// 此属性已声明为只读属性。 
        /// </summary> 
        public string[] PicPath { get; protected set; }
        #endregion
        /// <summary> 
        /// 上传单个文件 
        /// </summary> 
        /// <param name="sourcefile"></param> 
        /// <param name="upload"></param> 
        /// <returns></returns> 
        /// <author>Marc</author> 
        public virtual int SaveAs(HttpPostedFile sourcefile)
        {
            int result = 0;
            //未知错误 
            UploadResultEnum uploadResultEnum = UploadResultEnum.UnknownError;
            if (sourcefile == null)
            {
                //未指定要上传的对象 
                uploadResultEnum = UploadResultEnum.UploadedObjectIsNull;
            }
            else
            {
                uploadResultEnum = Upload(sourcefile);
            }
            result = (int)uploadResultEnum;
            return result;
        }
        /// <summary> 
        /// 上传文件 
        /// </summary> 
        /// <param name="sourcefile"></param> 
        /// <returns></returns> 
        /// <author>Marc</author> 
        private UploadResultEnum Upload(HttpPostedFile sourcefile)
        {
            #region 上传前检测 
            if (string.IsNullOrEmpty(UploadPhysicalPath))
            {
                //未配置或未指定文件的物理保存路径 
                return UploadResultEnum.UploadPhysicalPathNoSpecify;
            }
            string fileName = sourcefile.FileName;
            string fileExtention = Path.GetExtension(fileName);
            if (!CheckExtention(fileExtention))
            {
                //文件扩展名不允许 
                return UploadResultEnum.ExtentionIsNotAllowed;
            }
            int fileLength = sourcefile.ContentLength;
            if (fileLength <= 0 || fileLength > UploadLength * 1024)
            {
                //文件大小不在限定范围内 
                return UploadResultEnum.ContentLengthNotWithinTheScope;
            }
            //创建要保存的文件夹 
            string physicalPath = UploadPhysicalPath + SaveFolder + Folder;
            if (!Directory.Exists(physicalPath))
            {
                Directory.CreateDirectory(physicalPath);
            }
            #endregion
            string newFileName = "Ori_" + Guid.NewGuid().ToString() + fileExtention;
            //新文件相对物理路径 
            string newFilePath = physicalPath + newFileName;
            #region 保存原始文件 
            if (!IsMakeWatermark) //不启用水印时 
            {
                //保存文件 
                sourcefile.SaveAs(newFilePath);
            }
            else //要求生成水印 
            {
                Image bitmap = new Bitmap(sourcefile.InputStream);
                Graphics g = Graphics.FromImage(bitmap);
                g.InterpolationMode = InterpolationMode.High;
                g.SmoothingMode = SmoothingMode.AntiAlias;
                Image fromImg = null;
                try
                {
                    //清除整个绘图面并以透明背景色填充 
                    //g.Clear(Color.Transparent); 
                    if (WatermarkType == (int)WatermarkTypeEnum.String) //生成文字水印 
                    {
                        if (string.IsNullOrEmpty(Watermark))
                        {
                            //未指定水印的文字 
                            return UploadResultEnum.StringWatermarkNoSpecify;
                        }
                        Color color = Color.FromArgb(120, 255, 255, 255);
                        Brush brush = new SolidBrush(color);
                        // 自动根据界面来缩放字体大小 
                        int desiredWidth = (int)(bitmap.Width * .5);
                        Font font = new Font("Arial", 16, FontStyle.Regular);
                        SizeF stringSizeF = g.MeasureString(Watermark, font);
                        float Ratio = stringSizeF.Width / font.SizeInPoints;
                        int requiredFontSize = (int)(desiredWidth / Ratio);
                        // 计算图片中点位置 
                        Font requiredFont = new Font("Arial", requiredFontSize, FontStyle.Bold);
                        stringSizeF = g.MeasureString(Watermark, requiredFont);
                        int x = desiredWidth - (int)(stringSizeF.Width / 2);
                        int y = (int)(bitmap.Height * .5) - (int)(stringSizeF.Height / 2);
                        g.DrawString(Watermark, new Font("Verdana", requiredFontSize, FontStyle.Bold), brush, new Point(x, y));
                        bitmap.Save(newFilePath, ImageFormat.Jpeg);
                    }
                    else if (WatermarkType == (int)WatermarkTypeEnum.Image) //生成图片水印 
                    {
                        if (string.IsNullOrEmpty(ImageWartermarkPath))
                        {
                            //未指定图片水印的相对文件物理路径 
                            return UploadResultEnum.ImageWartermarkPathNoSpecify;
                        }
                        fromImg = Image.FromFile(ImageWartermarkPath);
                        g.DrawImage(fromImg, new Rectangle(bitmap.Width - fromImg.Width, bitmap.Height - fromImg.Height, fromImg.Width, fromImg.Height), 0, 0, fromImg.Width, fromImg.Height, GraphicsUnit.Pixel);
                        bitmap.Save(newFilePath, ImageFormat.Jpeg);
                    }
                }
                catch
                {
                    //上传原始文件失败 
                    return UploadResultEnum.UploadOriginalFileFailure;
                }
                finally
                {
                    if (fromImg != null)
                    {
                        fromImg.Dispose();
                    }
                    g.Dispose();
                    bitmap.Dispose();
                }
            }
            #endregion
            this.NewFilePath = newFilePath.Replace("\\", "/");
            #region 生成各种规格的缩略图 
            //生成各种规格的缩略图 
            if (PicSize != null && PicSize.Length > 0)
            {
                int width, height;
                ArrayList picPathArray = new ArrayList();
                for (int i = 0; i < PicSize.GetLength(0); i++)
                {
                    width = PicSize[i, 0];
                    height = PicSize[i, 1];
                    Guid tempGuid = Guid.NewGuid();
                    //缩略图名称 
                    string thumbnailFileName = physicalPath + tempGuid.ToString() + "_" + width.ToString() + "X" + height.ToString() + fileExtention;
                    if (!SaveThumb(sourcefile, width, height, thumbnailFileName))
                    {
                        //生成缩略失败 
                        return UploadResultEnum.CreateThumbnailImageFailure;
                    }
                    picPathArray.Add(thumbnailFileName.Replace("\\", "/"));
                }
                PicPath = (string[])picPathArray.ToArray(typeof(string));
            }
            #endregion
            //上传成功 
            return UploadResultEnum.Success;
        }
        /// <summary> 
        /// 生成缩略图 
        /// </summary> 
        /// <param name="sourcefile"></param> 
        /// <param name="width">生成缩略图的宽度</param> 
        /// <param name="height">生成缩略图的高度</param> 
        /// <param name="thumbnailFileName">缩略图生成路径，含盘符的绝对物理路径。</param> 
        /// <returns></returns> 
        /// <author>Marc</author> 
        private bool SaveThumb(HttpPostedFile sourcefile, int width, int height, string thumbnailFileName)
        {
            bool result = false;
            Image ori_img = Image.FromStream(sourcefile.InputStream);
            int ori_width = ori_img.Width;//650 
            int ori_height = ori_img.Height;//950 
            int new_width = width;//700 
            int new_height = height;//700 
                                    // 在此进行等比例判断,公式如下： 
            if (new_width > ori_width)
            {
                new_width = ori_width;
            }
            if (new_height > ori_height)
            {
                new_height = ori_height;
            }
            if ((double)ori_width / (double)ori_height > (double)new_width / (double)new_height)
            {
                new_height = ori_height * new_width / ori_width;
            }
            else
            {
                new_width = ori_width * new_height / ori_height;
            }
            Image bitmap = new Bitmap(new_width, new_height);
            Graphics g = Graphics.FromImage(bitmap);
            try
            {
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.InterpolationMode = InterpolationMode.High;
                g.Clear(System.Drawing.Color.Transparent);
                g.DrawImage(ori_img, new Rectangle(0, 0, new_width, new_height), new Rectangle(0, 0, ori_width, ori_height), GraphicsUnit.Pixel);
                bitmap.Save(thumbnailFileName, ImageFormat.Jpeg);
                result = true;
            }
            catch
            {
                result = false;
            }
            finally
            {
                if (ori_img != null)
                {
                    ori_img.Dispose();
                }
                if (bitmap != null)
                {
                    bitmap.Dispose();
                }
                g.Dispose();
                bitmap.Dispose();
            }
            return result;
        }
        /// <summary> 
        /// 检查文件扩展名 
        /// </summary> 
        /// <param name="extention"></param> 
        /// <returns></returns> 
        protected bool CheckExtention(string extention)
        {
            bool b = false;
            string[] extentions = this.UploadExtention.Split(',');
            for (int i = 0; i < extentions.Length; i++)
            {
                if (extention.ToLower() == extentions[i].ToLower())
                {
                    b = true;
                    break;
                }
            }
            return b;
        }
        /// <summary> 
        /// 返回上传结果 
        /// </summary> 
        /// <param name="result">消息集合</param> 
        /// <returns></returns> 
        /// <author>marc</author> 
        public string Error(int[] result)
        {
            string s = "";
            for (int i = 0; i < result.Length; i++)
            {
                s += "第" + (i + 1).ToString() + "张:";
                if (result[i] != 1)
                {
                    switch (result[i])
                    {
                        case (int)UploadResultEnum.UploadedObjectIsNull:
                            s += "未指定要上传的对象";
                            break;
                        case (int)UploadResultEnum.ExtentionIsNotAllowed:
                            s += "文件扩展名不允许";
                            break;
                        case (int)UploadResultEnum.ContentLengthNotWithinTheScope:
                            s += "文件大小不在限定范围内";
                            break;
                        case (int)UploadResultEnum.UploadPhysicalPathNoSpecify:
                            s += "未配置或未指定文件的物理保存路径";
                            break;
                        case (int)UploadResultEnum.ImageWartermarkPathNoSpecify:
                            s += "未指定图片水印的相对文件物理路径";
                            break;
                        case (int)UploadResultEnum.StringWatermarkNoSpecify:
                            s += "未指定水印的文字";
                            break;
                        case (int)UploadResultEnum.UploadOriginalFileFailure:
                            s += "上传原始文件失败";
                            break;
                        case (int)UploadResultEnum.CreateThumbnailImageFailure:
                            s += "生成缩略失败";
                            break;
                        case (int)UploadResultEnum.UnknownError:
                            s += "未知错误";
                            break;
                        default:
                            break;
                    }
                }
                else
                {
                    s += "上传成功";
                }
                s += ";\\r\\n";
            }
            return s;
        }
        /// <summary> 
        /// 返回上传结果 
        /// </summary> 
        /// <param name="result">消息值,int型</param> 
        /// <returns></returns> 
        /// <author>marc</author> 
        public string Error(int result)
        {
            string s = null;
            switch (result)
            {
                case (int)UploadResultEnum.UploadedObjectIsNull:
                    s += "未指定要上传的对象";
                    break;
                case (int)UploadResultEnum.ExtentionIsNotAllowed:
                    s += "文件扩展名不允许";
                    break;
                case (int)UploadResultEnum.ContentLengthNotWithinTheScope:
                    s += "文件大小不在限定范围内";
                    break;
                case (int)UploadResultEnum.UploadPhysicalPathNoSpecify:
                    s += "未配置或未指定文件的物理保存路径";
                    break;
                case (int)UploadResultEnum.ImageWartermarkPathNoSpecify:
                    s += "未指定图片水印的相对文件物理路径";
                    break;
                case (int)UploadResultEnum.StringWatermarkNoSpecify:
                    s += "未指定水印的文字";
                    break;
                case (int)UploadResultEnum.UploadOriginalFileFailure:
                    s += "上传原始文件失败";
                    break;
                case (int)UploadResultEnum.CreateThumbnailImageFailure:
                    s += "生成缩略失败";
                    break;
                case (int)UploadResultEnum.UnknownError:
                    s += "未知错误";
                    break;
                case (int)UploadResultEnum.Success:
                    s += "上传成功";
                    break;
                default:
                    break;
            }
            return s;
        }
    }
}
