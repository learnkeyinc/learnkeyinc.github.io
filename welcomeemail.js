let firstName,o365email,o365pw,voipextension,voippw,voicemailpw,adobeemail,adobepw
$("#submitinclusions").click(function() {
  let included = [];
  $("#inclusions input:checkbox").each(function() {
    let c = $(this);
    if (c.is(":checked")) {
      included.push(c.attr("id"));
    }
    $("#requiredinfo").empty();
    $.each(included,(i,v) => {
      getTemplate(v,"required");          
      $("#requiredinfo").append(`<div class="col-xs-4"><input id="${v}"></div>`);
    })
  });
});

function addTemplate(id) {
  let templates = getTemplates();
}

async function getpw(secret) {
  let expirationViews = $("#expirationviews").val();
  let expirationHours = $("#expirationhours").val();
  let url;
  $.post("https://cors.bridged.cc/https://quickforget.com/secret/submit/", { 
    secret: secret, 
    expire_after_views: expirationViews, 
    expire_after: expirationHours
  }, 
    function (a,b,c) { 
      url = c.getResponseHeader("x-final-url"); 
    }
  );
  return url;
}

function getTemplate(key,subkey) {
  let templates = {
    intro: {
      required: ["firstname"],
      text: `<td><p>${firstname},</p><p>Welcome to the LearnKey family! I manage LearnKey’s internal technology systems and subscription services. Getting set up at LearnKey is a straightforward process:</p><ol><li>Retrieve your passwords from all the links in the <strong>Temporary password</strong> column of the table below.</li><li>Log in at the account URLs and change your passwords. Most of your accounts will not work until you have performed this step.</li><li>Store your passwords in a secure location, such as a password manager or a handwritten notebook.</li></ol></td><td style="vertical-align:top"><img height=100 width=auto src="https://media-aws.onlineexpert.com/images/LK-Main-Black.png" alt="LearnKey logo" /></td>`
    },
    warning: {
      required: [],
      text: `<td colspan="2" style="background-color:#fff2cc; padding: 5px; border: 1px solid #ffc83d">&#x26a0; The password links have built-in time limits, so please perform these steps&nbsp;<em>today</em>&nbsp;even if you don’t need to use a particular service today. If any of the links do not work, please notify me immediately.</td>`
    },
    o365: {
      required: ["o365email","o365pw"],
      text: `<td>Microsoft Office 365 ProPlus</td><td>Outlook, Skype for Business, Word, Excel, PowerPoint, Access, OneNote, Publisher, InfoPath, etc.<ul><li>After setting a password, sign in to any Office app.</li><li>Keep Skype for Business running at all times.</li><li>Install this software on up to 5 computers. (Help: <a href="https://support.office.com/en-ie/article/Download-and-install-Office-using-Office-365-for-business-on-your-PC-72977511-dfd1-4d8b-856f-405cfb76839c">Windows</a> | <a href="https://support.office.com/en-ie/article/Download-and-install-Office-2016-for-Mac-using-Office-365-for-business-2eb5e0ad-eb5f-418c-a476-81be30e6fe4e">Mac</a>)</li></ul></td><td><a href="https://portal.office.com">portal.office.com</a></td><td>${o365email}</td>
      <td><a href="${o365pw}">Password</a></td>`
    },
    voip: {
      required: ["voipextension","voippw"],
      text: `<td>VoIP phone system</td><td>LearnKey’s telephone system operates your desk phone and voicemail and our teleconference rooms.<br></td><td><a href="http://voicemail.learnkey.com">voicemail.learnkey.com</a></td><td>${voipextension}</td><td><a href="${voippw}">Password</a></td>`
    },
    deskphone: {
      required: ["voicemailpw"],
      text: `<td>Desk phone</td><td>Your desk phone connects to the company VoIP system for outbound and inbound calls. You can also use it to check your voicemail.</td><td>Varies</td><td>N/A</td><td><a href="${voicemailpw}">Voicemail passcode</a></td>`
    },
    creativecloud: {
      required: ["adobeemail","adobepw"],
      text: `<td>Adobe Creative Cloud for Teams</td><td>Acrobat, Photoshop, Lightroom, InDesign, Illustrator, After Effects, Audition, Premiere Pro, etc.<ul><li>Log in to see the apps available to you.</li><li>Install this software on up to 2 computers. (<a href="https://helpx.adobe.com/creative-cloud/help/download-install-app.html">Help</a>)</li></ul></td><td><a href="https://account.adobe.com/">account.adobe.com</a></td><td>${adobeemail}</td><td>${adobepw}</td>`
    },
    ending: {
      required: [],
      text: `<td colspan="2"><p>The tech support team is here to serve you. If you have any questions, please email me directly or send an email to <a href="mailto:techsupport@learnkey.com">techsupport@learnkey.com</a>. We are also available on the phone at extension 293 or (800)&nbsp;482&#8209;8244.</p><p>I wish you the best as you begin your journey with LearnKey!</p></td>`
    }
  };
  return templates[key][subkey];
}