function show_upload_form(access_key, policy, signature, fname_hash, redirect) {
  var str = 
    "<form name='upload_form' id='upload-form' method='post' action='https://mixture-posts.s3.amazonaws.com/' enctype='multipart/form-data'>" + 
    '<input type="hidden" name="key" value="uploads/${filename}">' + 
    '<input type="hidden" name="AWSAccessKeyId" value="' + access_key + '">' + 
    '<input type="hidden" name="acl" value="public-read">' + 
    '<input type="hidden" name="success_action_redirect" value="' + redirect + '">' + 
    '<input type="hidden" name="policy" value="' + policy + '">' + 
    '<input type="hidden" name="signature" value="' + signature + '">' + 
    '<input type="hidden" name="Content-Type" value="image/jpg">' +
    "<input type='file' name='file' id='upload-button' onchange='upload(\"" + fname_hash +"\")'>" + 
    "</form>";
  $("div#upload-post").append(str);
}

function getExtention(fileName) {
  var ret = "nil";
  if (!fileName) {
    return ret;
  }
  var fileTypes = fileName.split(".");
  var len = fileTypes.length;
  if (len === 0) {
    return ret;
  }
  ret = fileTypes[len - 1];
  return ret;
}

function getContentType(extension) {
  var content_type = "";
  if (extension != "nil") {
    switch (extension) {
      case "jpg":
      case "jpeg":
        content_type = "image/jpeg";
        break;
      case "png":
        content_type = "image/png";
        break;
      case "txt":
      case "csv":
        content_type = "text/plain";
        break;
      case "zip":
        content_type = "application/zip";
        break;
      case "vmd":
        content_type = "application/octet-stream";
        break;
      default:
        content_type = "text/plain";
        break;
    }
  }
  return content_type;
}

function upload(fname_hash) {
  alert("start");
  var flist = document.getElementById("upload-button").files;
  var file_name = flist[0].name;
  var extension = getExtention(file_name).toLowerCase();
  var content_type = getContentType(extension);

  // フォームの中身を変更する
  document.upload_form["key"].value = "uploads/" + fname_hash + "." + extension;
  document.upload_form["Content-Type"].value = content_type;
  document.upload_form.submit();
}