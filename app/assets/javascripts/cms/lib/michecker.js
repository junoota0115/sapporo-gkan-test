this.Cms_Michecker = (function () {
  function Cms_Michecker(el) {
    this.$el = $(el);
    this.$btnStart = this.$el.find(".btn-michecker-start");
    this.$notice = this.$el.find(".michecker-notice");
    this.$frame = this.$el.find(".michecker__main-content");
    this.frame = this.$frame[0];
    this.$reportSelector = this.$el.find(".michecker-report__selector");
    this.$reportAccessibility = this.$el.find(".michecker-report__accessibility");
    this.$reportLowVision = this.$el.find(".michecker-report__low-vision")
    this.overlayElement = null;

    this.init();
  }

  Cms_Michecker.messages = {
    prepared: null,
    micheckerStarted: null,
    micheckerFailedToStart: null,
    micheckerUnknownError: null,
    micheckerCompleted: null,
    accessibilityReportLoadError: null,
    lowVisionReportLoadError: null
  }

  Cms_Michecker.lastNoneEmptyLog = function(logs) {
    if (!logs || logs.length === 0) {
      return null;
    }

    for (var i = logs.length - 1; i >= 0; i--) {
      var log = logs[i];
      if (!log) {
        continue;
      }

      log = log.replace(/^.*-- :/, '').trim();
      if (log.length === 0) {
        continue;
      }

      return log;
    }

    return null;
  }

  function isFrameLoaded(frame) {
    var frameDoc = frame.contentDocument || frame.contentWindow.document;
    if (!frameDoc || !frameDoc.readyState) {
      return false;
    }

    return frameDoc.readyState === "complete";
  }

  Cms_Michecker.prototype.init = function() {
    var self = this;

    if (isFrameLoaded(self.frame)) {
      self.onFrameLoaded();
    } else {
      this.$frame.one("load", function (_ev) {
        self.onFrameLoaded();
      });
    }

    this.$btnStart.on("click", function(ev) {
      self.onBtnMicheckerStartClicked(ev);
    });

    this.$reportSelector.find("[name=report-type]").on("change", function(ev) {
      self.onReportTypeChanged(ev);
    });

    this.$el.on("click", ".michecker-report__result-container table tr", function(ev) { self.highlightElemetByCssPath(ev); });
    this.$el.on("click", "[data-css-path]", function(ev) { self.highlightElemetByCssPath(ev); });
  };

  Cms_Michecker.prototype.onFrameLoaded = function() {
    this.$notice.html(Cms_Michecker.messages.prepared);
    this.$btnStart.prop("disabled", false);

    this.$reportSelector.removeClass("hide").find("[name=report-type]").trigger("change");
  }

  Cms_Michecker.prototype.onBtnMicheckerStartClicked = function() {
    this.$btnStart.prop("disabled", true);

    this.$reportSelector.addClass("hide");
    this.$reportAccessibility.addClass("hide");
    this.$notice.html(SS.loading).removeClass("hide");

    var self = this;
    $.ajax({
      url: this.$btnStart.data("href"),
      method: "POST",
      dataType: "json",
    }).done(function(data, status, xhr) {
      self.onMicheckerStartedSuccessfully(data, status, xhr);
    }).fail(function(xhr, status, error) {
      self.onMicheckerFailedToStart(xhr, status, error);
    });
  }

  Cms_Michecker.prototype.onMicheckerStartedSuccessfully = function(data) {
    var url = data.status_check_url;
    var self = this;

    var d = $.Deferred();

    var checkJobStatus = function() {
      $.ajax({
        url: url,
        method: "GET",
        dataType: "json",
      }).done(function(data, _status, _xhr) {
        if (data.state === "completed") {
          d.resolve();
          return;
        }

        if (data.logs && data.logs.length > 0) {
          var lastLog = Cms_Michecker.lastNoneEmptyLog(data.logs);
          if (lastLog && lastLog.length > 0) {
            self.$notice.html(lastLog);
          }
        }

        setTimeout(checkJobStatus, 5000);
      }).fail(function(_xhr, _status, _error) {
        d.reject();
      });
    };

    var promise = d.promise();
    promise.done(function() {
      self.$btnStart.prop("disabled", false);
      self.$notice.html(Cms_Michecker.messages.micheckerCompleted);
      self.$reportSelector.removeClass("hide");
      self.$reportSelector.find("[name=report-type]").trigger("change");
    }).fail(function(_xhr, _status, _error) {
      self.$btnStart.prop("disabled", false);
      self.$notice.html(Cms_Michecker.messages.micheckerUnknownError);
    });

    setTimeout(checkJobStatus, 5000);

    this.$notice.html(Cms_Michecker.messages.micheckerStarted + " " + SS.loading).removeClass("hide");
  };

  Cms_Michecker.prototype.onMicheckerFailedToStart = function() {
    this.$btnStart.prop("disabled", false);
    this.$notice.html(Cms_Michecker.messages.micheckerFailedToStart).removeClass("hide");
  };

  Cms_Michecker.prototype.onReportTypeChanged = function(ev) {
    this.hideOverlay();

    var selectedOption = ev.currentTarget.options[ev.currentTarget.selectedIndex];
    if (! selectedOption) {
      this.$reportAccessibility.addClass("hide");
      this.$reportLowVision.addClass("hide");
      return;
    }

    if (selectedOption.value === "accessibility") {
      this.loadAccessibilityReport(selectedOption.dataset.href);
    } else {
      this.loadLowVisionReport(selectedOption.dataset.href);
    }
  };

  Cms_Michecker.prototype.loadAccessibilityReport = function(url) {
    this.$reportAccessibility.html(SS.loading).removeClass("hide");
    this.$reportLowVision.addClass("hide");

    var self = this;
    $.ajax({
      url: url, method: "GET"
    }).done(function(data, _status, _xhr) {
      self.$reportAccessibility.html(data);
    }).fail(function(_xhr, _status, _error) {
      self.$reportAccessibility.html(Cms_Michecker.messages.accessibilityReportLoadError);
    });
  }

  Cms_Michecker.prototype.loadLowVisionReport = function(url) {
    this.$reportAccessibility.addClass("hide");
    this.$reportLowVision.html(SS.loading).removeClass("hide");

    var self = this;
    $.ajax({
      url: url, method: "GET"
    }).done(function(data, _status, _xhr) {
      self.$reportLowVision.html(data);
    }).fail(function(_xhr, _status, _error) {
      self.$reportLowVision.html(Cms_Michecker.messages.lowVisionReportLoadError);
    });
  }

  Cms_Michecker.prototype.createOverlay = function() {
    var el = this.frame.contentDocument.createElement("div");
    el.style.display = "none";
    el.style.backgroundColor = "rgba(255, 0, 0, .4)";
    // 表示崩れを防ぐために box-model を明示的に設定
    el.style.border = "none";
    el.style.margin = "0";
    el.style.padding = "0";
    el.style.boxSizing = "border-box";
    // 初期位置は (0,0) で初期サイズは 0x0。
    el.style.position = "absolute";
    el.style.left = "0";
    el.style.top = "0";
    el.style.width = "0";
    el.style.height = "0";

    this.frame.contentDocument.body.appendChild(el);

    this.overlayElement = el;
    return el;
  };

  Cms_Michecker.prototype.moveOverlayAndShow = function(el) {
    var rect = el.getBoundingClientRect();
    var x = rect.x + this.frame.contentWindow.scrollX;
    var y = rect.y + this.frame.contentWindow.scrollY;

    this.frame.contentWindow.scrollTo(x, y > 50 ? y - 50 : 0);

    if (!this.overlayElement) {
      this.createOverlay();
    }

    this.overlayElement.style.left = x + "px";
    this.overlayElement.style.top = y + "px";
    this.overlayElement.style.width = rect.width + "px";
    this.overlayElement.style.height = rect.height + "px";
    this.overlayElement.style.display = "block";
  };

  Cms_Michecker.prototype.hideOverlay = function() {
    if (!this.overlayElement) {
      return;
    }

    this.overlayElement.style.display = "none";
  };

  Cms_Michecker.prototype.highlightElemetByCssPath = function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    this.hideOverlay();

    var cssPath = ev.currentTarget.dataset.cssPath;
    if (!cssPath) {
      return;
    }

    var targetElement = this.frame.contentDocument.querySelector(cssPath);
    if (!targetElement) {
      return;
    }

    this.moveOverlayAndShow(targetElement);
  };

  return Cms_Michecker;
})();
