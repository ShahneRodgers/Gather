import $ from 'jquery'

window.$ = $;

// Import Zurb foundation
import Foundation from 'foundation-sites';
$(document).foundation();

// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import socket from "./socket"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import { vote, complete_task, setLocale } from "./resources"
import { submitComment, editComment, updateComment, deleteComment } from "./comments"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';

import '@fullcalendar/core/main.css';
import '@fullcalendar/daygrid/main.css';

window.vote = vote;
window.complete_task = complete_task;

window.Calendar = Calendar;
window.dayGridPlugin = dayGridPlugin;
window.interactionPlugin = interactionPlugin;
window.setLocale = setLocale;

window.submitComment = submitComment;
window.editComment = editComment;
window.deleteComment = deleteComment;
window.updateComment = updateComment;