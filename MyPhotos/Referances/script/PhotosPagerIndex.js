var baseUrl = '../../';

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

function Modify(id) {
    $.get("/Photos/AddNew").then(
    function (r) {
        $("<div id='editModal'></div>").html(r).dialog({
            //width: 540,
            modal: true,
            closable: true,
            title: "添加图片"
        });
    });
};

function Download(id) {
    //debugger
    arr = id.split("+");
    var type = arr[0];
    var id = parseInt(arr[1]);
    //var id = $(".img-thumbnail.img-responsive").attr("id");
    //alert(id);
    var download_span = "download_span+" + id;
    var download_count = document.getElementById(download_span).innerHTML;//string
    var click_span = "click_span+" + id;
    var click_count = document.getElementById(click_span).innerHTML;//string
    document.getElementById(download_span).innerHTML = parseInt(download_count) + 1;
    document.getElementById(click_span).innerHTML = parseInt(click_count) + 1;

    window.location.href = "/Photos/Download/" + id;
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

function Edit(id) {
    //debugger
    //alert(id);
    arr = id.split("+");
    var type = arr[0];
    var id = parseInt(arr[1]);
    var span = type + "_span+" + id;
    var click_span = "click_span+" + id;
    var count = document.getElementById(span).innerHTML;//string
    var click_count = document.getElementById(click_span).innerHTML;//string
    //alert(typeof count);
    //alert(span);
    //alert(typeof arr[0] + "\n" + typeof arr[1]);
    //return;
    //var type = id;
    //var id = $(".img-thumbnail.img-responsive").attr("id");
    switch (type) {
        case "click": type = 1; break;
        case "download": type = 2; break;
        case "up": type = 3; break;
        case "down": type = 4; break;
        default: return;
    }
    //alert("type=" + type + "\nid=" + id);
    $.ajax({
        url: baseUrl + 'Photos/Update?&id=' + id + '&type=' + type,
        type: 'GET',
        data: { "id": id, "type": type },
        async: true,
        cache: false,
        contentType: false,
        processData: false,
        success: function () {
            if (span != click_span) {
                document.getElementById(span).innerHTML = parseInt(count) + 1;
                document.getElementById(click_span).innerHTML = parseInt(click_count) + 1;
            } else document.getElementById(click_span).innerHTML = parseInt(click_count) + 1;

            //alert("success");
            //window.location.href = "/Photos/PagerIndex";
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //alert(XMLHttpRequest.status + "\n" + XMLHttpRequest.readyState + "\n" + textStatus);
            //window.location.href = "/Photos/PagerIndex";
        },
    });
};