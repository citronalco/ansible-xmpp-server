VirtualHost "bytewerk.org"

name = "bytewerk.org Messenger Service";

-- mod_conversejs:
conversejs_options = {
	view_mode = "fullscreen";
	play_sounds = "true";
	discover_connection_methods = "true"; -- enable users from XMPP domains not hosted on this server. Seems to break everything if conversejs_resources/_cdn is set. (default: false)
	i18n = "de"; -- language autodetection is flaky, force German as default (default: unset -> autodetect)
	csi_waiting_time = "10"; -- after XX seconds set user status to "inactive" (default: 0 -> never)
	auto_away = "180"; -- after XX seconds set user status to "away" (default: 0 -> never)
	auto_xa = "600"; -- after XX seconds set user status to "extended away" (default: 0 -> never)
	auto_reconnect = "true"; -- on network failures try to reconnect automatically
	allow_non_roster_messaging = "true"; -- receive message from users not in the roster, like in conversations.im (default: false)
	allow_chat_pending_contacts = "true"; -- allow users to chat with pending contacts, like in conversations.im (default: false)
	auto_register_muc_nickname = "true"; -- automatically register user's nickname in MUC
	muc_domain = "conference.bytewerk.org";  -- default domain for new MUCs (default: unset -> users have to type in MUC domain)
}
conversejs_tags = {
        -- Load libsignal-protocol.js for OMEMO support (GPLv3; be aware of licence implications)
        [[<script src="https://xmpp.bytewerk.org/conversejs-libsignal-protocol-javascript/libsignal-protocol.js"></script>]];
}


------ Components ------
--- Set up a MUC (multi-user chat) room server: [XEP-0045]
Component "conference.bytewerk.org" "muc"
	restrict_room_creation = false  -- everyone can create rooms
	modules_enabled = {
	    "muc_limits";  -- limit max. event rate in a MUC room
	    "muc_mam";  -- enable archiving of MUC messages
	    "vcard_muc";  -- enable vCards for MUC rooms
	    "muc_cloud_notify";  -- enable push notifications for iOS devices
	}
	muc_log_by_default = true;  -- enable conversation logging by default (can be disabled in room config)


-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
-- Listens on port 5000
Component "proxy.bytewerk.org" "proxy65"
	-- proxy65_acl = { "bytewerk.org" };


-- PubSub ("Publish-Subscribe") [XEP-0060]
Component "pubsub.bytewerk.org" "pubsub"
	pubsub_max_items = 10000  -- required for Movim, see https://github.com/movim/movim/wiki/Configure%20prosody


-- Handle file uploads with external webserver and share_v2.php (file is provided by mod_http_upload_external) [XEP-0363]
Component "upload.bytewerk.org" "http_upload_external"
	http_upload_external_base_url = "https://upload.bytewerk.org/share_v2.php/"  -- URL to share_v2.php script
	http_upload_external_secret = "SHAREPHPPASSWORDBYTEWERK"  -- shared secret, must also be entered in share_v2.php
	http_upload_external_file_size_limit = 20*1024*1024  -- max. upload size in bytes (default: 100 MByte)
	http_upload_external_protocol = "v2";  -- see docs of mod_http_upload_external

