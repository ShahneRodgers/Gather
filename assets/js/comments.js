

export function submitComment(path, textarea, csrf_token){
    sendComment(path, textarea, csrf_token);
    
    textarea.value = "";
}

export function updateComment(path, commentDiv, csrf_token){
    var textarea = commentDiv.getElementsByTagName("textarea")[0];

    sendComment(path, textarea, csrf_token);

    var comment = document.createElement('div');
    comment.innerHTML = textarea.value;
    comment.id = textarea.id;

    textarea.parentElement.replaceChild(comment, textarea);
    commentDiv.getElementsByTagName("a")[0].classList.toggle("hide");
}

function sendComment(path, textarea, csrf_token){
    var req = new XMLHttpRequest();
    req.open('POST', path);
    req.setRequestHeader("X-CSRF-Token", csrf_token);
    req.send(textarea.value);
}

export function editComment(commentDiv, commentId){
    var comment = document.getElementById("comment-" + commentId);
    var editable = document.createElement('textarea');
    editable.innerHTML = comment.innerHTML;
    editable.id = comment.id;

    comment.parentElement.replaceChild(editable, comment);
    commentDiv.getElementsByTagName("a")[0].classList.toggle("hide");
}

export function deleteComment(commentDiv, path, commentId){
    var req = new XMLHttpRequest();
    req.open('GET', path + '/delete/' + commentId);
    req.send(null);

    commentDiv.parentElement.removeChild(commentDiv);
}