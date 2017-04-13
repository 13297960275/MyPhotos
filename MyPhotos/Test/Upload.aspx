<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="MyPhotos.Upload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:FileUpload ID="FileUpload1" runat="server" />
            <asp:Button ID="Button1" runat="server" Text="上传" Width="54px" OnClick="Button1_Click" />
            <asp:Label ID="Label1" runat="server" Text="" Style="color: Red"></asp:Label>
            <asp:Image runat="server" ID="Image1" Style="z-index: 102; left: 20px; position: absolute; top: 49px"
                Width="73px" />
        </div>
    </form>
</body>
</html>
