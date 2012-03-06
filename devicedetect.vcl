#
# detectdevice.vcl - regex based device detection for Varnish
# http://github.com/lkarsten/varnish-devicedetect/
#
# Author: Lasse Karstensen <lasse@varnish-software.com>

sub devicedetect {
    unset req.http.X-UA-Device;
    set req.http.X-UA-Device = "pc";

    if    (req.http.User-Agent ~ "(?i)ip(hone|od)") { set req.http.X-UA-Device = "mobile-iphone"; }
    elsif (req.http.User-Agent ~ "(?i)ipad")        { set req.http.X-UA-Device = "tablet-ipad"; }
    # how do we differ between an android phone and an android tablet?
    # http://stackoverflow.com/questions/5341637/how-do-detect-android-tablets-in-general-useragent
    elsif (req.http.User-Agent ~ "(?i)android.*(mobile|mini)") { set req.http.X-UA-Device = "mobile-android"; }       
    # android 3/honeycomb was just about tablet-only, and any phones will probably handle a bigger page layout.
    elsif (req.http.User-Agent ~ "(?i)android 3")              { set req.http.X-UA-Device = "tablet-android"; }
    # may very well give false positives towards android tablets. Suggestions welcome.
    elsif (req.http.User-Agent ~ "(?i)android")         { set req.http.X-UA-Device = "tablet-android"; }

    elsif (req.http.User-Agent ~ "^HTC" ||
        req.http.User-Agent ~ "Fennec" || 
        req.http.User-Agent ~ "IEMobile" ||
        req.http.User-Agent ~ "BlackBerry" ||
        req.http.User-Agent ~ "SymbianOS.*AppleWebKit" ||
        req.http.User-Agent ~ "Opera Mobi") {
        set req.http.X-UA-Device = "mobile-smartphone";
    }
    elsif (req.http.User-Agent ~ "(?i)symbian" ||
        req.http.User-Agent ~ "(?i)^sonyericsson" ||
        req.http.User-Agent ~ "(?i)^nokia" ||
        req.http.User-Agent ~ "(?i)^samsung" ||
        req.http.User-Agent ~ "(?i)^lg" ||
	req.http.User-Agent ~ "(?i)bada" ||
	req.http.User-Agent ~ "(?i)blazer" ||
	req.http.User-Agent ~ "(?i)cellphone" ||
	req.http.User-Agent ~ "(?i)iemobile" ||
	req.http.User-Agent ~ "(?i)midp-2.0" ||
	req.http.User-Agent ~ "(?i)u990" ||
	req.http.User-Agent ~ "(?i)netfront" ||
	req.http.User-Agent ~ "(?i)opera mini" ||
	req.http.User-Agent ~ "(?i)palm" ||
	req.http.User-Agent ~ "(?i)nintendo wii" ||
	req.http.User-Agent ~ "(?i)playstation portable" ||
	req.http.User-Agent ~ "(?i)portalmmm" ||
	req.http.User-Agent ~ "(?i)proxinet" ||
	req.http.User-Agent ~ "(?i)sonyericsson" ||
	req.http.User-Agent ~ "(?i)symbian" ||
	req.http.User-Agent ~ "(?i)windows\ ?ce" ||
	req.http.User-Agent ~ "(?i)winwap" ||
	req.http.User-Agent ~ "(?i)eudoraweb" ||
	req.http.User-Agent ~ "(?i)htc" ||
	req.http.User-Agent ~ "(?i)240x320" ||
	req.http.User-Agent ~ "(?i)avantgo") { 
        set req.http.X-UA-Device = "mobile-generic";
    }

    # handle overrides
    if (req.http.Cookie ~ "(i?)X-UA-Device-force") {
        # ;?? means zero or one ;, non-greedy to match the first.
        set req.http.X-UA-Device = regsub(req.http.Cookie, "(?i).*X-UA-Device-force=([^;]+);??.*", "\1");
    }
}

# vim: sw=4:tw=120 # meh
