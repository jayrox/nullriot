// Include this for common XSS data
// Created 2016-08-22 by Aerstone
// Updated 2020-06-18 by Eric Getchell
// Original Author: Chris Campbell
/*
Copyright (c) 2017 Quest Consultants LLC (DBA Aerstone)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

var xss_width = 500;

var xss_locations = xss_locations || [];

var xss_styles = {
    "modal": `text-align: center;
        width: ${xss_width}px;
        height: auto;
        color: black;
        padding: 5px;
        z-index: 999;
        word-wrap: break-word;
        background-color: white;
        border-style: solid;
        border-width: 2px;
        border-color: black;`,
    "header": "height: 100px;",
    "content": `padding: 10px;
        text-align: left;`,
    "overlay": "background: rgba(255,2,0,0.8)",
    "footer": `display: block;
        position: absolute;
        bottom: 0px;
        height: 40px;
        width: 100%;
        background: rgba(255,220,220,1);
        color: black;
        border-width: 3px;
        border-color: red;
        border-top-style: solid`,
    "footer_image": "float: left;",
    "footer_text": `text-align: center;
         margin-top: 10px;`,
    "footer_menu": `float: right;
        margin-top: 10px;
        margin-right: 10px;`,
};

var xss_open = () => {
    xss_close();

    const modal = xss_modal();
    const overlay = xss_overlay();

    modal.style.position = 'fixed';
    modal.style.top = '40px';
    modal.style.left = '0px';
    modal.style.right = '0px';
    modal.style.width = xss_width;
    modal.style.marginLeft = 'auto';
    modal.style.marginRight = 'auto';

    overlay.style.position = 'fixed';
    overlay.style.top = '0px';
    overlay.style.left = '0px';
    overlay.style.right = '0px';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(100,0,0,0.4)';

    overlay.onclick = () => xss_close();

    document.body.appendChild(overlay);
    document.body.appendChild(modal);
};

var xss_close = () => {
    if (!document.getElementById('A_XSS') && !document.getElementById('XSSOverlay')) return;

    document.body.removeChild(document.getElementById('A_XSS'));
    document.body.removeChild(document.getElementById('XSSOverlay'));
    xss_close();
};

var xss_is_auto_enabled = () => {
    if (localStorage.getItem("A_XSSAuto") == undefined) {
        localStorage.setItem("A_XSSAuto", "true");
    }
    return localStorage.getItem("A_XSSAuto") == 'true' ? true : false;
};

var xss_toggle_auto = (cb) =>
    localStorage.setItem("A_XSSAuto", String(cb.checked));

var xss_footer = () => {
    let d;
    if (document.getElementById("A_XSSFooter")) {
        d = document.getElementById("A_XSSFooter");
        d.innerHtml = '';
    } else {
        d = document.createElement("div");
        d.id = 'A_XSSFooter';
    }

    d.innerHTML = `<div style="${xss_styles['footer']}">
        <div style="${xss_styles['footer_image']}">
            <img height="40px" src="data:image/png;base64,${company_logo}"/>
        </div>
        <div style="${xss_styles['footer_menu']}">
            Auto Open: <input id='A_XSSAutoCB' type='checkbox'
            ${xss_is_auto_enabled() ? "checked='true' " : ''}
            onclick='xss_toggle_auto(this)'/>
            <button onclick='xss_open()'>Open</button>
        </div>
        <div style="${xss_styles['footer_text']}">
            Cross Site Scripting (XSS)
            ${xss_locations.length > 1 ? ` x ${xss_locations.length}` : ''}
        </div>
    </div>`;

    return d;
};

var xss_header = () =>
    `<div style="${xss_styles['header']}">
        <img src='data:image/png;base64,${company_logo}'/>
        <div>Cross Site Scripting (XSS)
            ${xss_locations.length > 1 ? `<br>${xss_locations.length} Instances` : ''}
        </div>
    </div>`;

var xss_content = () =>
    `<div style="${xss_styles['content']}"><hr/>
        <p>Host: ${document.location.hostname}</p>
        <p>URL: ${document.location.pathname}</p>
        <p>Args: ${(document.location.href.split('?')[1])}</p><hr/>
        <p>Cookies:<br/> ${document.cookie}</p>
    </div>`;

var xss_overlay = () => {
    const d = document.createElement("div");
    d.id = 'XSSOverlay';
    d.innerHTML = `<div style="${xss_styles['overlay']}"></div>`;
    return d;
};

var xss_modal = () => {
    let d;
    if (document.getElementById("A_XSS")) {
        d = document.getElementById("A_XSS");
        d.innerHtml = '';
    } else {
        d = document.createElement("div");
        d.id = 'A_XSS';
    }

    d.innerHTML = `<div style="${xss_styles['modal']}">
        ${xss_header()}
        ${xss_content()}
    </div>`;

    return d;
};

var xss_pin_footer_top = () => { };

var xss_init = () => {
    // Create modal div
    xss_locations.push(document.currentScript);

    const footer = xss_footer();

    document.body.appendChild(footer);

    footer.style.position = 'fixed';
    footer.style.bottom = '0px';
    footer.style.left = '0px';
    footer.style.right = '0px';
    footer.style.height = '10px';
    footer.style.width = '100%';

    if (xss_is_auto_enabled()) xss_open();
    console.log("XSS Executed");
};

document.onkeypress = (e) => keyHandler(e);
document.onkeydown = (e) => keyHandler(e);

var keyHandler = (e) => {
    e = e || window.event;
    if ("key" in e) {
        if (e.key == "Escape" || e.key == "Esc") {
            xss_close();
        }
    }
    if (e.keyCode === 27) xss_close();
};

var company_logo = `
    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
    QmCC`;

xss_init();
