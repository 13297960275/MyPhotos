//已登录用户修改资料和密码的鼠标移入移出事件驱动函数
$(document).ready(function () {
    $("#userDetails").hover(function () {
        $("#userManager").show();
    }, function () {
        $("#userManager").hide();
    });
});

//在Onchange 事件中添加输入文件元素，并在JS方法SingleFileSelected使用，因此在用户选择和修改文件时都会调用此方法。在该方法中，我们将选择输入文件元素和访问FileList的文件对象，选择第一个文件files[0]，因此我们可以得到文件名，文件类型等信息。
function singleFileSelected(evt) {
    //var selectedFile = evt.target.files can use this  or select input file element 
    //and access it's files object
    var selectedFile = ($("#UploadedFile"))[0].files[0];//FileControl.files[0];
    if (selectedFile) {
        var FileSize = 0;
        var imageType = /image.*/;
        if (selectedFile.size > 1048576) {
            FileSize = Math.round(selectedFile.size * 100 / 1048576) / 100 + " MB";
        }
        else if (selectedFile.size > 1024) {
            FileSize = Math.round(selectedFile.size * 100 / 1024) / 100 + " KB";
        }
        else {
            FileSize = selectedFile.size + " Bytes";
        }
        // here we will add the code of thumbnail preview of upload images
        $("#FileName").text("Name : " + selectedFile.name);
        $("#FileType").text("type : " + selectedFile.type);
        $("#FileSize").text("Size : " + FileSize);
    }
}

//在SingleFileSelected 方法中使用File reader，用于预览图像
if (selectedFile.type.match(imageType)) {
    //可以通过File reader对象从内存读取上传文件内容。reader 对象提供很多事件，onload,onError以及四种读取数据的函数readAsBinaryString(), readAsText()，readAsArrayBuffer(), readAsDataURL(),result属性表示文件内容。该属性只有当读操作执行完成后才有效，数据格式根据调用的初始化读操作制定的。
    var reader = new FileReader();
    reader.onload = function (e) {
        $("#Imagecontainer").empty();
        var dataURL = reader.result;
        var img = new Image()
        img.src = dataURL;
        img.className = "thumb";
        $("#Imagecontainer").append(img);
    };
    reader.readAsDataURL(selectedFile);
}

//将已上传的文件发送到服务器，因此添加Onclick事件，并在JS uploadFile()方法中调用.该方法中，发送表单，使用Form 数据对象来序列化文件值，我们可以手动创建formdata数据的实例化，通过调用append()方法将域值挂起，或是通过检索HTML 表单的FormData对象。
function UploadFile() {
    //we can create form by passing the form to Constructor of formData object
    //or creating it manually using append function 
    //but please note file name should be same like the action Parameter
    //var dataString = new FormData();
    //dataString.append("UploadedFile", selectedFile);
    var form = $('#FormUpload')[0];
    var dataString = new FormData(form);
    $.ajax({
        url: '/Photos/Upload',  //Server script to process data
        type: 'POST',
        xhr: function () {  // Custom XMLHttpRequest
            var myXhr = $.ajaxSettings.xhr();
            if (myXhr.upload) { // Check if upload property exists
                //myXhr.upload.onprogress = progressHandlingFunction
                myXhr.upload.addEventListener('progress', progressHandlingFunction,
                 false); // For handling the progress of the upload
            }
            return myXhr;
        },
        //Ajax events
        success: successHandler,
        error: errorHandler,
        complete: completeHandler,
        // Form data
        data: dataString,
        //Options to tell jQuery not to process data or worry about content-type.
        cache: false,
        contentType: false,
        processData: false
    });
}

//提供检验上传文件Size 是否可计算，使用e.loaded和e.total计算出已上传的百分数。
function progressHandlingFunction(e) {
    if (e.lengthComputable) {
        var percentComplete = Math.round(e.loaded * 100 / e.total);
        $("#FileProgress").css("width",
         percentComplete + '%').attr('aria-valuenow', percentComplete);
        $('#FileProgress span').text(percentComplete + "%");
    }
    else {
        $('#FileProgress span').text('unable to compute');
    }
}

//在MultiplefileSelected中添加onChange事件，将所有的文件列出，并允许拖拽文件。将选择和拖拽文件操作的变量设置为全局变量selectedFiles，然后扫描 selectedfiles中的每个文件，将从 DataURLreader对象中调用Read 方法读取文件。
function MultiplefileSelected(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    $('#drop_zone').removeClass('hover');
    selectedFiles = evt.target.files || evt.dataTransfer.files;
    if (selectedFiles) {
        $('#Files').empty();
        for (var i = 0; i < selectedFiles.length; i++) {
            DataURLFileReader.read(selectedFiles[i], function (err, fileInfo) {
                if (err != null) {
                    var RowInfo = '<div id="File_' + i + '" class="info"><div class="InfoContainer">' + '<div class="Error">' + err + '</div>' + '<div data-name="FileName"  class="info">' + fileInfo.name + '</div>' + '<div data-type="FileType" class="info">' + fileInfo.type + '</div>' + '<div data-size="FileSize" class="info">' + fileInfo.size() + '</div></div><hr/></div>';
                    $('#Files').append(RowInfo);
                }
                else {
                    var image = '<img src="' + fileInfo.fileContent + '"class="thumb" title="' + fileInfo.name + '" />';
                    var RowInfo = '<div id="File_' + i + '"class="info"><div class="InfoContainer">' + '<div data_img="Imagecontainer">' + image + '</div>' + '<div data-name="FileName"  class="info">' + fileInfo.name + '</div>' + '<div data-type="FileType" class="info">' + fileInfo.type + '</div>' + '<div data-size="FileSize"  class="info">' + fileInfo.size() + '</div></div><hr/></div>';
                    $('#Files').append(RowInfo);
                }
            });
        }
    }
}

//DataURLreader对象可调用read方法，并将File对象和回调方法作为read方法参数，创建FileReader，并修改了FileReader的Onload和onerror回调函数。调用 readAsDataURL 方法来读文件。
var DataURLFileReader = {
    read: function (file, callback) {
        var reader = new FileReader();
        var fileInfo = {
            name: file.name,
            type: file.type,
            fileContent: null,
            size: function () {
                var FileSize = 0;
                if (file.size > 1048576) {
                    FileSize = Math.round(file.size * 100 / 1048576) / 100 + " MB";
                }
                else if (file.size > 1024) {
                    FileSize = Math.round(file.size * 100 / 1024) / 100 + " KB";
                }
                else {
                    FileSize = file.size + " bytes";
                }
                return FileSize;
            }
        };
        if (!file.type.match('image.*')) {
            callback("file type not allowed", fileInfo);
            return;
        }
        reader.onload = function () {
            fileInfo.fileContent = reader.result;
            callback(null, fileInfo);
        };
        reader.onerror = function () {
            callback(reader.error, fileInfo);
        };
        reader.readAsDataURL(file);
    }
};

//实现拖拽操作，在drop_zone 元素中添加dragover和drop事件。
var dropZone = document.getElementById('drop_zone');
dropZone.addEventListener('dragover', handleDragOver, false);
dropZone.addEventListener('drop', MultiplefileSelected, false);
dropZone.addEventListener('dragenter', dragenterHandler, false);
dropZone.addEventListener('dragleave', dragleaveHandler, false);

//当文件拖到目标位置时触发dragover事件，修改默认浏览器及datatransfer的dropEffect 属性，
function handleDragOver(evt) {
    evt.preventDefault();
    evt.dataTransfer.effectAllowed = 'copy';
    evt.dataTransfer.dropEffect = 'copy';
}

//添加“上传按钮”，通过Onclick事件来调用UploadMultipleFiles方法。该方法与上文提到的Uploadfile方法类似，不同的是手动验证formdata对象值。
function UploadMultipleFiles() {
    // here we will create FormData manually to prevent sending mon image files
    var dataString = new FormData();
    //var files = document.getElementById("UploadedFiles").files;
    for (var i = 0; i < selectedFiles.length; i++) {
        if (!selectedFiles[i].type.match('image.*')) {
            continue;
        }
    }
    // AJAX Request code here
}