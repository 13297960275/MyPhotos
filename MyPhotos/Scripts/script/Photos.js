var baseUrl = '../../';
$(function () { $('#editModal').modal('hide') });
$(function () {
    $('#editModal').on('hide.bs.modal', function () {
        alert('嘿，我听说您喜欢模态框...');
    })
});

function OpenAddNew() {
    $.get("/Photos/AddNew").then(
    function (r) {
        $("<div id='DivCreateNew'></div>").html(r).dialog({
            width: 540,
            modal: true,
            closable: true,
            title: "添加图片"
        });
    });
};

function del(id) {
    $("#del-confirm").dialog({
        resizable: true,
        modal: true,
        buttons: {
            删除: function () {
                $.ajax({
                    url: baseUrl + 'Photos/Del/' + id,
                    type: 'POST',
                    data: { "id": id },
                    async: true,
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function () {
                        //alert("成功");
                        $("#del-confirm").dialog("close");
                        window.location.href = "/Photos/PagerIndex";
                    },
                    error: function (returndata) {
                        alert("失败");
                        $("#del-confirm").dialog("close");
                        window.location.href = "/Photos/PagerIndex";
                    }
                });
            },
            取消: function () {
                $(this).dialog("close");
            }
        }
    });
    //if (confirm('确定删除？')) {
    //    window.location.href = "/Photos/Delete/" + id;
    //} else return;
};

function Download(id) {
    alert(id);
    //window.location.href = "/Photos/Download/" + id;
    //window.location.href = "/Photos/GetFileByPath/" + id;
    //$.ajax({//ajax能获取文件数据，无法完成下载
    //    url: baseUrl + 'Photos/Download/' + id,
    //    type: 'POST',
    //    data: { "id": id },
    //    async: true,
    //    cache: false,
    //    contentType: false,
    //    processData: false,
    //    success: function (data) {
    //        alert("success");
    //    },
    //    error: function () {
    //        alert("error");
    //    }
    //})
};