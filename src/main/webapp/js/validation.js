/**
 * SlotSync — Client-side Form Validation
 * ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 * Mirrors server-side ValidationUtil.java rules so errors are caught
 * before the round-trip to the server.
 *
 * Covers:
 *  • Login form          (#login-form)
 *  • Register form       (#register-form)
 *  • Contact form        (#contact-form)
 *  • Profile info form   (#profile-info-form)
 *  • Change password     (#profile-pw-form)
 *  • Availability form   (#avail-form)
 *  • Booking form        (#booking-form)
 */

'use strict';

/* ══════════════════════════════════════════════════════════
   RULE FUNCTIONS  (mirror ValidationUtil.java exactly)
══════════════════════════════════════════════════════════ */

const Rules = {

    /** Must not be blank */
    required(value) {
        return value !== null && value.trim().length > 0;
    },

    /** ^[A-Za-z ]+$  — only letters and spaces (same regex as Java) */
    validName(value) {
        return /^[A-Za-z ]+$/.test(value.trim());
    },

    /** ^[A-Za-z0-9+_.-]+@(.+)$  — same regex as Java */
    validEmail(value) {
        return /^[A-Za-z0-9+_.\-]+@.+$/.test(value.trim());
    },

    /** At least 6 characters (same rule as Java) */
    validPassword(value) {
        return value.length >= 6;
    },

    /** Both password fields must match */
    passwordsMatch(pw1, pw2) {
        return pw1 === pw2;
    },

    /** Valid phone — digits, spaces, +, -, () allowed, min 7 digits */
    validPhone(value) {
        const digits = value.replace(/\D/g, '');
        return digits.length >= 7 && /^[+\d\s\-().]+$/.test(value.trim());
    },

    /** Time string HH:MM — end must be after start */
    endAfterStart(startVal, endVal) {
        if (!startVal || !endVal) return true; // skip if empty
        return startVal < endVal;
    }
};

/* ══════════════════════════════════════════════════════════
   UI HELPERS
══════════════════════════════════════════════════════════ */

/**
 * Mark a field as invalid — adds red border + shows error message.
 * @param {HTMLElement} field  - the input/textarea
 * @param {string}      msg    - human-readable error text
 */
function setError(field, msg) {
    field.style.borderColor = '#ef4444';
    field.style.boxShadow   = '0 0 0 3px rgba(239,68,68,.12)';

    // Find or create the sibling error span
    let errEl = field.parentElement.querySelector('.v-error');
    if (!errEl) {
        errEl = document.createElement('span');
        errEl.className = 'v-error';
        errEl.style.cssText = 'display:block;font-size:11.5px;color:#ef4444;margin-top:4px;';
        field.parentElement.appendChild(errEl);
    }
    errEl.textContent = msg;
}

/**
 * Clear the invalid state from a field.
 * @param {HTMLElement} field
 */
function clearError(field) {
    field.style.borderColor = '';
    field.style.boxShadow   = '';
    const errEl = field.parentElement.querySelector('.v-error');
    if (errEl) errEl.remove();
}

/**
 * Show a top-level form error banner (replaces/creates #form-error-banner).
 * @param {HTMLFormElement} form
 * @param {string}          msg
 */
function showFormBanner(form, msg) {
    let banner = form.querySelector('.v-banner');
    if (!banner) {
        banner = document.createElement('div');
        banner.className = 'v-banner';
        banner.style.cssText =
            'padding:10px 14px;border-radius:8px;font-size:13px;font-weight:500;' +
            'margin-bottom:14px;background:#fef2f2;color:#991b1b;border:1px solid #fca5a5;';
        form.prepend(banner);
    }
    banner.textContent = '✖ ' + msg;
    banner.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function clearFormBanner(form) {
    const banner = form.querySelector('.v-banner');
    if (banner) banner.remove();
}

/** Attach real-time clearing of error on input */
function liveValidate(field) {
    field.addEventListener('input', () => clearError(field));
}

/* ══════════════════════════════════════════════════════════
   FORM VALIDATORS
══════════════════════════════════════════════════════════ */

/* ── LOGIN ── */
function validateLogin(form) {
    const email = form.querySelector('#login-email, [name="email"]');
    const pw    = form.querySelector('#login-password, [name="password"]');
    let ok = true;

    if (email) {
        clearError(email);
        if (!Rules.required(email.value)) {
            setError(email, 'Email is required.'); ok = false;
        } else if (!Rules.validEmail(email.value)) {
            setError(email, 'Enter a valid email address.'); ok = false;
        }
    }

    if (pw) {
        clearError(pw);
        if (!Rules.required(pw.value)) {
            setError(pw, 'Password is required.'); ok = false;
        } else if (!Rules.validPassword(pw.value)) {
            setError(pw, 'Password must be at least 6 characters.'); ok = false;
        }
    }

    return ok;
}

/* ── REGISTER ── */
function validateRegister(form) {
    const name    = form.querySelector('#reg-name, [name="fullName"]');
    const email   = form.querySelector('#reg-email, [name="email"]');
    const pw      = form.querySelector('#reg-password, [name="password"]');
    const pwConf  = form.querySelector('#reg-confirm, [name="confirmPassword"]');
    let ok = true;

    if (name) {
        clearError(name);
        if (!Rules.required(name.value)) {
            setError(name, 'Full name is required.'); ok = false;
        } else if (!Rules.validName(name.value)) {
            setError(name, 'Name may only contain letters and spaces.'); ok = false;
        }
    }

    if (email) {
        clearError(email);
        if (!Rules.required(email.value)) {
            setError(email, 'Email is required.'); ok = false;
        } else if (!Rules.validEmail(email.value)) {
            setError(email, 'Enter a valid email address.'); ok = false;
        }
    }

    if (pw) {
        clearError(pw);
        if (!Rules.required(pw.value)) {
            setError(pw, 'Password is required.'); ok = false;
        } else if (!Rules.validPassword(pw.value)) {
            setError(pw, 'Password must be at least 6 characters.'); ok = false;
        }
    }

    if (pwConf && pw) {
        clearError(pwConf);
        if (!Rules.required(pwConf.value)) {
            setError(pwConf, 'Please confirm your password.'); ok = false;
        } else if (!Rules.passwordsMatch(pw.value, pwConf.value)) {
            setError(pwConf, 'Passwords do not match.'); ok = false;
        }
    }

    return ok;
}

/* ── CONTACT ── */
function validateContact(form) {
    const name    = form.querySelector('#contact-name, [name="name"]');
    const email   = form.querySelector('#contact-email, [name="email"]');
    const message = form.querySelector('#contact-message, [name="message"]');
    let ok = true;

    if (name) {
        clearError(name);
        if (!Rules.required(name.value)) {
            setError(name, 'Your name is required.'); ok = false;
        } else if (!Rules.validName(name.value)) {
            setError(name, 'Name may only contain letters and spaces.'); ok = false;
        }
    }

    if (email) {
        clearError(email);
        if (!Rules.required(email.value)) {
            setError(email, 'Email is required.'); ok = false;
        } else if (!Rules.validEmail(email.value)) {
            setError(email, 'Enter a valid email address.'); ok = false;
        }
    }

    if (message) {
        clearError(message);
        if (!Rules.required(message.value)) {
            setError(message, 'Please enter a message.'); ok = false;
        } else if (message.value.trim().length < 10) {
            setError(message, 'Message must be at least 10 characters.'); ok = false;
        }
    }

    return ok;
}

/* ── PROFILE INFO ── */
function validateProfileInfo(form) {
    const name  = form.querySelector('#profile-name, [name="fullName"]');
    const email = form.querySelector('#profile-email, [name="email"]');
    const phone = form.querySelector('#profile-phone, [name="phone"]');
    let ok = true;

    if (name) {
        clearError(name);
        if (!Rules.required(name.value)) {
            setError(name, 'Name is required.'); ok = false;
        } else if (!Rules.validName(name.value)) {
            setError(name, 'Name may only contain letters and spaces.'); ok = false;
        }
    }

    if (email) {
        clearError(email);
        if (!Rules.required(email.value)) {
            setError(email, 'Email is required.'); ok = false;
        } else if (!Rules.validEmail(email.value)) {
            setError(email, 'Enter a valid email address.'); ok = false;
        }
    }

    if (phone && phone.value.trim().length > 0) {
        clearError(phone);
        if (!Rules.validPhone(phone.value)) {
            setError(phone, 'Enter a valid phone number.'); ok = false;
        }
    }

    return ok;
}

/* ── CHANGE PASSWORD ── */
function validateChangePassword(form) {
    const current = form.querySelector('#pw-current, [name="currentPassword"]');
    const newPw   = form.querySelector('#pw-new, [name="newPassword"]');
    const confirm = form.querySelector('#pw-confirm, [name="confirmPassword"]');
    let ok = true;

    if (current) {
        clearError(current);
        if (!Rules.required(current.value)) {
            setError(current, 'Current password is required.'); ok = false;
        }
    }

    if (newPw) {
        clearError(newPw);
        if (!Rules.required(newPw.value)) {
            setError(newPw, 'New password is required.'); ok = false;
        } else if (!Rules.validPassword(newPw.value)) {
            setError(newPw, 'Password must be at least 6 characters.'); ok = false;
        }
    }

    if (confirm && newPw) {
        clearError(confirm);
        if (!Rules.required(confirm.value)) {
            setError(confirm, 'Please confirm your new password.'); ok = false;
        } else if (!Rules.passwordsMatch(newPw.value, confirm.value)) {
            setError(confirm, 'Passwords do not match.'); ok = false;
        }
    }

    return ok;
}

/* ── AVAILABILITY ── */
function validateAvailability(form) {
    const days = ['mon','tue','wed','thu','fri','sat','sun'];
    let ok = true;

    days.forEach(function(day) {
        const toggle = form.querySelector('[name="avail_' + day + '"]');
        const start  = form.querySelector('[name="start_' + day + '"]');
        const end    = form.querySelector('[name="end_' + day + '"]');

        if (!toggle || !toggle.checked) return; // skip disabled days

        if (start) clearError(start);
        if (end)   clearError(end);

        if (start && !Rules.required(start.value)) {
            setError(start, 'Start time required.'); ok = false;
        }
        if (end && !Rules.required(end.value)) {
            setError(end, 'End time required.'); ok = false;
        }
        if (start && end && Rules.required(start.value) && Rules.required(end.value)) {
            if (!Rules.endAfterStart(start.value, end.value)) {
                setError(end, 'End must be after start.'); ok = false;
            }
        }
    });

    return ok;
}

/* ── BOOKING ── */
function validateBooking(form) {
    const service  = form.querySelector('#booking-service, [name="serviceId"]');
    const employee = form.querySelector('#booking-employee, [name="employeeId"]');
    const date     = form.querySelector('#booking-date, [name="date"]');
    const slot     = form.querySelector('#booking-slot, [name="slot"]');
    let ok = true;

    if (service) {
        clearError(service);
        if (!Rules.required(service.value) || service.value === '0') {
            setError(service, 'Please select a service.'); ok = false;
        }
    }
    if (employee) {
        clearError(employee);
        if (!Rules.required(employee.value) || employee.value === '0') {
            setError(employee, 'Please select a staff member.'); ok = false;
        }
    }
    if (date) {
        clearError(date);
        if (!Rules.required(date.value)) {
            setError(date, 'Please pick a date.'); ok = false;
        } else {
            const picked = new Date(date.value);
            const today  = new Date(); today.setHours(0,0,0,0);
            if (picked < today) {
                setError(date, 'Date cannot be in the past.'); ok = false;
            }
        }
    }
    if (slot) {
        clearError(slot);
        if (!Rules.required(slot.value)) {
            setError(slot, 'Please select a time slot.'); ok = false;
        }
    }

    return ok;
}

/* ══════════════════════════════════════════════════════════
   FORM → VALIDATOR MAP  &  AUTO-ATTACH
══════════════════════════════════════════════════════════ */

const formValidators = {
    'login-form'       : validateLogin,
    'register-form'    : validateRegister,
    'contact-form'     : validateContact,
    'profile-info-form': validateProfileInfo,
    'profile-pw-form'  : validateChangePassword,
    'avail-form'       : validateAvailability,
    'booking-form'     : validateBooking
};

document.addEventListener('DOMContentLoaded', function () {

    Object.keys(formValidators).forEach(function (id) {
        const form = document.getElementById(id);
        if (!form) return;

        const validator = formValidators[id];

        // Attach live-clear to every input/textarea/select inside the form
        form.querySelectorAll('input, textarea, select').forEach(liveValidate);

        // Intercept submit
        form.addEventListener('submit', function (e) {
            clearFormBanner(form);
            const valid = validator(form);
            if (!valid) {
                e.preventDefault();
                // Focus the first errored field
                const firstErr = form.querySelector('[style*="border-color"]');
                if (firstErr) firstErr.focus();
            }
        });
    });
});
