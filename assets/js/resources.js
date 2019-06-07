export function vote(resource_id, type){
    var req = new XMLHttpRequest();
    req.open('GET', '/resources/votes/' + resource_id + '/' + type, true);
    req.send(null);
}

export function complete_task(subtask_id, path, csrf_token){
    var req = new XMLHttpRequest();
    req.open('GET', path);
    req.setRequestHeader("X-CSRF-Token", csrf_token);
    req.send(null);

    var classes = document.getElementById(subtask_id).classList;
    classes.toggle('todo');
    classes.toggle('completed');
}

export function setLocale(value){
    var url = new URL(document.location);
    var params = url.searchParams;
    params.set("locale", value);
    document.location.href = url.origin + url.pathname + "?" + params.toString();
}