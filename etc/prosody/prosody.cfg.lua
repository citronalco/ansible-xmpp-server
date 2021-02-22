-- Prosody Example Configuration File
--
-- Information on configuring Prosody can be found on our
-- website at https://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running this command:
--     prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- The only thing left to do is rename this file to remove the .dist ending, and fill in the
-- blanks. Good luck, and happy Jabbering!

---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see https://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { "sqozz@bytewerk.org", "cfr34k@bytewerk.org", "geierb@jabber.geierb.de", "bg3992@bingo-ev.de" }

-- Enable use of libevent for better performance under high load
-- For more information see: https://prosody.im/doc/libevent
use_libevent = true

-- Prosody will always look in its source directory for modules, but
-- this option allows you to specify additional locations where Prosody
-- will look for modules first. For community modules, see https://modules.prosody.im/
plugin_paths = { "/usr/local/lib/prosody-modules/" }

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
-- Documentation for bundled modules can be found at: https://prosody.im/doc/modules
modules_enabled = {

	-- Generally required
		"roster"; -- Allow users to have a roster. Recommended ;) [XEP-0237]
		"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
		"tls"; -- Add support for secure TLS on c2s/s2s connections
		"dialback"; -- s2s dialback support [XEP-0220]
		"disco"; -- Service discovery [XEP-0030]
		"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.

	-- Not essential, but recommended
		"carbons"; -- Keep multiple clients in sync [XEP-0280]
		"pep"; -- Enables users to publish their mood, activity, playing music and more [XEP-0163]
		"private"; -- Private XML storage (for room bookmarks, etc.) [XEP-0049]
		"blocklist"; -- Allow users to block communications with other users [XEP-0191]
		"vcard4"; -- Allow users to set vCards (vCard4 format) [XEP-0153]
		"vcard_legacy"; -- Allow users to set vCards (older formats) [XEP-0054]

	-- Nice to have
		"version"; -- Replies to server version requests [XEP-0092]
		"uptime"; -- Report how long server has been running [XEP-0012]
		"time"; -- Let others know the time here on this server [XEP-0090]
		"ping"; -- Replies to XMPP pings with pongs - keeps client connections behind NAT open [XEP-0199]
		"register"; -- Allow users to register on this server using a client and change passwords [XEP-0077]
		"mam"; -- Store messages in an archive and allow users to access it [XEP-0313]
		"mam_adhoc"; -- Allows clients to set their archive preferences
		"cloud_notify"; -- Push notifications for iOS devices [XEP-0357]
		-- "cloud_notify_filters";
		-- "cloud_notify_encrypted;

	-- Admin interfaces
		"admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands [XEP-0133]
		-- "admin_telnet"; -- Opens telnet console interface on localhost port 5582

	-- HTTP modules
		"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP" [XEP-0124] [XEP-0206]
		-- "websocket"; -- XMPP over WebSockets -- FIXME: Verbindungen über Websocket funktionieren nicht. Nach dem Verbindungsaufbau passiert nichts mehr - bis zum Timeout
		"http_altconnect"; -- Publish available BOSH, websocket and other HTTP endpoints for autodetection via .well-known HTTP method [XEP-0156]
		-- "http_files"; -- Serve static files from a directory over HTTP, e.g. a registration form

	-- Other specific functionality
		"limits"; -- Enable bandwidth limiting for XMPP connections
		"groups"; -- Enable server defined groups
		-- "alias"; -- Allow server defined Layer 8 JID redirects (display message "User foo@bar.com can be contacted at foo@baz.net"). Aliases must be defined and followed manually.
		"bookmarks";  -- Bookmarks conversion [XEP-0411]
		"server_contact_info"; -- Publish contact information for this service [XEP-0157]
		"announce"; -- Send announcement to all online users
		-- "welcome"; -- Welcome users who register accounts
		-- "watchregistrations"; -- Alert admins of registrations
		-- "motd"; -- Send a message to users when they log in
		-- "legacyauth"; -- Legacy authentication. Only used by some old clients and bots. [XEP-0078]
		-- "proxy65"; -- Enables a file transfer proxy service which clients behind NAT can use [XEP-0065] -- enabled below as Component
		-- "log_auth"; -- On failed authentication attempts log IP address (useful for fail2ban)
		"limit_auth"; -- Throttle authentication attempts
		-- "offline_email"; -- Forward messages to offline users per email (JID must equal email address)

	-- Client State Indicators
		"csi"; -- Client state indication [XEP-0352]
		"csi_battery_saver"; -- Don't send unimportant stanzas (presence, typing,...) imediatelly to inactice devices [XEP-0085]
		"lastactivity"; -- Allows users to query how long another user has been idle [XEP-0012]
		"idlecompat"; -- Idle indication for some clients [XEP-0319]

	-- Stream management
		"smacks"; -- Stream Management to survive small network outages [XEP-0198]
		"bidi"; -- Allow single, bidirectional connection to servers  [XEP-0288]
		"s2s_auth_compat"; -- Support s2s authentication with slightly broken servers (e.g. OpenFire 3.8). See https://prosody.im/doc/certificates#server-to-server_encryption_issues

	-- WebRTC/Jingle - Needs hint to TURN/STUN server. Either use "turncredentials" or "extdisco" & "external_services"
		 -- "turncredentials";
		 "extdisco"; -- [XEP-0215]
		 "external_services"; -- Inform clients about our STUN+TURN server (depends on mod_extdisco)

	-- Converse.js
		"conversejs";  -- serve a small HTML snippet in http://<virtualhost>:5280/conversejs

}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
	-- "offline"; -- Store offline messages
	-- "c2s"; -- Handle client connections
	-- "s2s"; -- Handle server-to-server connections
	"websocket"; -- FIXME: Verbindungen über Websocket funktionieren nicht. Nach dem Verbindungsaufbau passiert nichts mehr - bis zum Timeout
}


---------- Module configuration ----------
-- core:
ignore_presence_priority = true;  -- forward messages to all connected clients of a user, not only to the one with the highest priority
reload_modules = { "groups", "tls" };  -- reload certificates and groups_file (see below) on "prosodyctl reload"

-- mod_mam:
-- default_archive_policy = true;  -- enable message archiving by default (default: true)
-- max_archive_query_results = 20;  -- number of messages that are allowed to be retrieved in one request page. clients will fetch further pages automatically (default: 20)

-- mod_smacks:
-- smacks_hibernation_time = 300;  -- number of seconds a disconnected session should stay alive to allow silent reconnects (default: 300)

-- mod_cloud_notify:
-- push_notification_with_body = false;  -- Whether or not to send the message body to remote pubsub node (default: false)
push_notification_with_sender = true;  -- Whether or not to send the message sender to remote pubsub node (default: false)

-- mod_groups:
groups_file = "/etc/prosody/sharedGroups.txt";  -- assign users to admin-defined groups (default: empty)

-- mod_server_contact_info: public contact addresses for abuse handling (default: empty)
contact_info = {
	abuse = { "https://bingo-ev.de"  },
	admin = { "https://bingo-ev.de" }
};

-- mod_limit_auth:
limit_auth_period = 15;  -- within 15 seconds...
limit_auth_max = 5; -- ...tolerate no more than 5 failed authentication attempts

-- WebRTC/Jingle support - either use mod_turncredentials OR mod_external_services with mod_extdisco
-- turncredentials_host = "xmpp.bytewerk.org";  -- TURN server URL
-- turncredentials_secret = "njfVWfWs8uuxNzEZ";  -- TURN server shared secret (see /etc/coturn/turnserver.conf)
external_services = {
	{
	    type = "stun",
	    host = "xmpp.bytewerk.org",
	    transport = "udp",
	    port = 3478
	},
	{
	    type = "turn",
	    host = "xmpp.bytewerk.org",
	    transport = "udp",
	    port = 3478,
	    secret = "TURNSERVERPASSWORD"
	}
}

-- mod_bosh: listens on /http-bind
-- bosh_max_inactivity = 60; -- Maximum amount of time in seconds a client may remain silent for, with no requests, before getting kicked (default: 60)
cross_domain_bosh = true; -- CORS header for BOSH (either list of domains or "true" for *) (default: hostname or, if, set, host in "http_external_url")
consider_bosh_secure = true; -- allow operations requiring encryption over plain HTTP (i.e. when using a reverse proxy for HTTPS) (default: false)

-- mod_websocket: listens on /xmpp-websocket
cross_domain_websocket = true; -- CORS header for websocket (either list of domains or "true" for *) (default: hostname or, if, set, host in "http_external_url")
consider_websocket_secure = true;  -- Allow operations requiring encryption over plain HTTP (i.e. when using a reverse proxy for HTTPS) (default: false)

-- mod_http: HTTPS is done by an Apache2 reverse proxy, so Prosody's HTTPS server can be disabled and HTTP limited to localhost
http_external_url = "https://xmpp.bytewerk.org"  -- Promote all HTTP(S) services using this base URL
http_interfaces = { "127.0.0.1", "::1" }  -- Only listen for HTTP requests on localhost, port 5280 (default: { "*", "::" })
https_interfaces = { }  -- Do not listen for HTTPS requests on any interface, port 5281 - this disables Prosody's HTTPS server (default: { "*", "::" })

-- mod_auth_imap: If VirtualHost (bingo-ev.de) uses IMAP for authentication, use this server:
imap_auth_host = "mail.bingo-ev.de"
imap_auth_port = 993

-- mod_pubsub:
pep_max_items = 10000; -- required for Movim web client (see https://github.com/movim/movim/wiki/Configure%20prosody)

-- mod_conversejs:
conversejs_resources = "/usr/local/conversejs/conversejs/package/dist"; -- use a local provided converse.js (default: unset -> use CDN)

-----------------------------------------


-- Unix specific
pidfile = "/run/prosody/prosody.pid"

-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- To allow Prosody to offer secure authentication mechanisms to clients, the
-- default provider stores passwords in plaintext. If you do not trust your
-- server please see https://prosody.im/doc/modules/mod_auth_internal_hashed
-- for information about using the hashed backend.

authentication = "internal_hashed"

-- Disable account creation by default, for security
-- For more information see https://prosody.im/doc/creating_accounts
allow_registration = false

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.
c2s_require_encryption = true

-- Allow legacy SSL for older clients [XEP-0368]
legacy_ssl_ports = { 5223, 5225 };  -- 5223: bytewerk.org, 5225: bingo-ev.de (see SRV records)
-- certificates for legacy_ssl_ports (default: cert from "ssl" option)
legacy_ssl_ssl = {
	[5223] = {
	    key = "/etc/prosody/certs/bytewerk.org/privkey.pem";
	    certificate = "/etc/prosody/certs/bytewerk.org/fullchain.pem";
	};
	[5225] = {
	    key = "/etc/prosody/certs/bingo-ev.de/privkey.pem";
	    certificate = "/etc/prosody/certs/bingo-ev.de/fullchain.pem";
	};
}

-- Force servers to use encrypted connections? This option will
-- prevent servers from authenticating unless they are using encryption.
-- Note that this is different from authentication
s2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?
-- This provides ideal security, but requires servers you communicate
-- with to support encryption AND present valid, trusted certificates.
-- NOTE: Your version of LuaSec must support certificate verification!
-- For more information see https://prosody.im/doc/s2s#security
s2s_secure_auth = false

-- Some servers have invalid or self-signed certificates. You can list
-- remote domains here that will not be required to authenticate using
-- certificates. They will be authenticated using DNS instead, even
-- when s2s_secure_auth is enabled.

--s2s_insecure_domains = { "insecure.example" }

-- Even if you leave s2s_secure_auth disabled, you can still require valid
-- certificates for some domains by specifying a list here.

--s2s_secure_domains = { "jabber.org" }

-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See https://prosody.im/doc/storage for more info.

storage = "sql" -- Default is "internal"

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
--sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
sql = {
	driver = "PostgreSQL",
	database = "DATABASENAME",
	username = "DATABASEUSER",
	password = "DATABASEPASSWORD",
	host = "localhost"
}

-- Archiving configuration
-- If mod_mam is enabled, Prosody will store a copy of every message. This
-- is used to synchronize conversations between multiple clients, even if
-- they are offline. This setting controls how long Prosody will keep
-- messages in the archive before removing them.
archive_expires_after = "1m" -- Remove archived messages after 1 month

-- You can also configure messages to be stored in-memory only. For more
-- archiving options, see https://prosody.im/doc/modules/mod_mam

-- Logging configuration
-- For advanced logging see https://prosody.im/doc/logging
log = {
	info = "/var/log/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
	error = "/var/log/prosody/prosody.err";
	-- "*syslog"; -- Uncomment this for logging to syslog
	-- "*console"; -- Log to the console, useful for debugging with daemonize=false
}

-- Uncomment to enable statistics
-- For more info see https://prosody.im/doc/statistics
statistics = "internal"

-- Certificates
-- Every virtual host and component needs a certificate so that clients and
-- servers can securely verify its identity. Prosody will automatically load
-- certificates/keys from the directory specified here.
-- For more information, including how to use 'prosodyctl' to auto-import certificates
-- (from e.g. Let's Encrypt) see https://prosody.im/doc/certificates

-- Location of directory to find certificates in (relative to main config file):
certificates = "/etc/prosody/certs"



----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.


------ Additional config files ------
-- For organizational purposes you may prefer to add VirtualHost and
-- Component definitions in their own config files. This line includes
-- all config files in /etc/prosody/conf.d/

Include "conf.d/*.cfg.lua"
