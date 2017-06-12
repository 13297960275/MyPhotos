//点击取消选择后恢复空值
function reupload() {
    document.getElementById('uploadFile').value = "";
    document.getElementById('img').src = "";
    document.getElementById('fs').innerText = "";
    //$('#uploadFile').attr('value', "");
    //$('#img').attr('src', "");
    //$('#fs').attr('innerText', '');
    $('#reselect').hide();
};
$(function () {
    //选择图片后显示预览和文件大小
    //debugger
    $('#uploadFile').on("change", function () {
        var file = this.files[0];
        if (this.files && file) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#reselect').show();
                $('#img').attr('src', e.target.result);
                //$('#fn').text(file.name);
                $('#fs').text(file.size / 1024 / 1024 + "Mb");
            }
            reader.readAsDataURL(file);
        }
    })
});
function btnsubmit() {
    //判断是否选择文件
    var name = document.getElementById('uploadFile').value;//获取文件值
    if (!name) {
        alert("请选择文件！");
        return false;
    }

    //判断文件大小是否超过10M
    var size = document.getElementById('uploadFile').files[0].size;
    if (size > 10240000) {
        alert("允许上传的文件大小最大为10M，请重新选择文件，谢谢合作！");
        reupload();
        return false;
    }

    //判断文件类型是否允许上传
    var isnext = false;
    var ext = name.substr(name.lastIndexOf(".") + 1).toLocaleLowerCase();//获取文件后缀名
    var filetypes = ["jpg", "png", "jpeg", "bmp"];//图片后缀  //暂不允许上传GIF   "gif",
    for (var i = 0; i < filetypes.length; i++) {
        if (filetypes[i] == ext) {
            isnext = true;
            break;
        }
    }
    if (!isnext) {
        alert("请选择图片文件！");
        reupload();
        return false;
    }
}