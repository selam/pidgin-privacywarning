use IPC::Open2 qw(open2);
use POSIX;
use Purple;
use HTML::Entities;

%PLUGIN_INFO = (
	perl_api_version => 2,
	name => "PrivacyWarning",
	version => "0.1a",
	summary => "Perl plugin that provides send privacy notifications to user.",
	description => "Send privacy warning." ,
	author => "Timu Eren (selamtux\@gmail.com)",
	url => "http://github.com/selam/sendprivacy",
	load => "plugin_load",
	unload => "plugin_unload",
	prefs_info => "prefs_info_handler"
);

sub plugin_init {
	return %PLUGIN_INFO;
}

sub plugin_load {
	my $plugin = shift;
	Purple::Debug::info("privacywarning", "plugin_load() - Test Plugin Loaded.\n");
	Purple::Prefs::add_none("/plugins/core/perl_privacywarning");
	Purple::Prefs::add_bool("/plugins/core/perl_privacywarning/send_warning_enable", 1);
	Purple::Prefs::add_string("/plugins/core/perl_privacywarning/warning_message", "");


	Purple::Signal::connect(Purple::Conversations::get_handle(),
		"conversation-created", $plugin, \&conversation_created_handler, 0);	
}

sub plugin_unload {
	my $plugin = shift;
	Purple::Debug::info("privacywarning", "plugin_unload() - Test Plugin Unloaded.\n");
}

sub prefs_info_handler {
	$frame = Purple::PluginPref::Frame->new();

	$ppref = Purple::PluginPref->new_with_name_and_label(
		"/plugins/core/perl_privacywarning/send_warning_enable", "Send privacy information to users");
	$frame->add($ppref);

	$ppref = Purple::PluginPref->new_with_name_and_label(
		"/plugins/core/perl_privacywarning/warning_message", "Warning message to send remote user");
	$frame->add($ppref);

	return $frame;
}

sub conversation_created_handler {
	my ($conversation) = @_;
        
        Purple::Debug::info("privacywarning", "conversation_created_handler() ");
        
        if (Purple::Prefs::get_bool("/plugins/core/perl_privacywarning/send_warning_enable")) {

            Purple::Debug::info("privacywarning", "conversation_created_handler() - sending message enable");
            
            my $privacy_message = Purple::Prefs::get_string("/plugins/core/perl_privacywarning/warning_message");

            if ($privacy_message ne "")
            {
                Purple::Debug::info("privacywarning", "conversation_created_handler() - message is:  $privacy_message");

                $conversation->get_im_data()->send($privacy_message);
            }    
        }
}




