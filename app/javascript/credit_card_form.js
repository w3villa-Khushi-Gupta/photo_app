document.addEventListener('DOMContentLoaded', function() {
    var show_error, stripeResponseHandler, submitHandler;
    submitHandler = function(event) {
      var form = event.target;
      var submitButton = form.querySelector("input[type=submit]");
      submitButton.disabled = true;
      if (typeof Stripe !== 'undefined') {
        Stripe.card.createToken(form, stripeResponseHandler);
      } else {
        show_error("Failed to load credit card processing functionality. Please reload this page in your browser.");
      }
      return false;
    };
    var ccForm = document.querySelector('.cc_form');
    ccForm.addEventListener('submit', submitHandler);
    stripeResponseHandler = function(status, response) {
      var token, form;
      form = document.querySelector('.cc_form');
      if (response.error) {
        console.log(response.error.message);
        show_error(response.error.message);
        form.querySelector("input[type=submit]").disabled = false;
      } else {
        token = response.id;
        var tokenInput = document.createElement("input");
        tokenInput.setAttribute("type", "hidden");
        tokenInput.setAttribute("name", "payment[token]");
        tokenInput.value = token;
        form.appendChild(tokenInput);
        document.querySelector("[data-stripe=number]").remove();
        document.querySelector("[data-stripe=cvv]").remove();
        document.querySelector("[data-stripe=exp-year]").remove();
        document.querySelector("[data-stripe=exp-month]").remove();
        document.querySelector("[data-stripe=label]").remove();
        form.submit();
      }
      return false;
    };
    show_error = function(message) {
      var flashMessages = document.getElementById('flash-messages');
      if (!flashMessages) {
        var container = document.querySelector('div.container.main div:first');
        flashMessages = document.createElement('div');
        flashMessages.id = 'flash-messages';
        container.insertBefore(flashMessages, container.firstChild);
      }
      flashMessages.innerHTML = '<div class="alert alert-warning"><a class="close" data-dismiss="alert">×</a><div id="flash_alert">' + message + '</div></div>';
      var alertElement = document.querySelector('.alert');
      setTimeout(function() {
        alertElement.style.display = 'none';
      }, 5000);
      return false;
    };
  });