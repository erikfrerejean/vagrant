require "vagrant"

module VagrantPlugins
  module CFEngine
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :deb_repo_file
      attr_accessor :deb_repo_line
      attr_accessor :force_bootstrap
      attr_accessor :install
      attr_accessor :mode
      attr_accessor :policy_server_address
      attr_accessor :repo_gpg_key_url
      attr_accessor :yum_repo_file
      attr_accessor :yum_repo_url

      def initialize
        @deb_repo_file    = UNSET_VALUE
        @deb_repo_line    = UNSET_VALUE
        @force_bootstrap  = UNSET_VALUE
        @install          = UNSET_VALUE
        @mode             = UNSET_VALUE
        @policy_server_address = UNSET_VALUE
        @repo_gpg_key_url = UNSET_VALUE
        @yum_repo_file    = UNSET_VALUE
        @yum_repo_url     = UNSET_VALUE
      end

      def finalize!
        if @deb_repo_file == UNSET_VALUE
          @deb_repo_file = "/etc/apt/sources.list.d/cfengine-community.list"
        end

        if @deb_repo_line == UNSET_VALUE
          @deb_repo_line = "deb http://cfengine.com/pub/apt $(lsb_release -cs) main"
        end

        @force_bootstrap = false if @force_bootstrap == UNSET_VALUE

        @install = true if @install == UNSET_VALUE
        @install = @install.to_sym if @install.respond_to?(:to_sym)

        @mode = :bootstrap if @mode == UNSET_VALUE
        @mode = @mode.to_sym

        @policy_server_address = nil if @policy_server_address == UNSET_VALUE

        if @repo_gpg_key_url == UNSET_VALUE
          @repo_gpg_key_url = "http://cfengine.com/pub/gpg.key"
        end

        if @yum_repo_file == UNSET_VALUE
          @yum_repo_file = "/etc/yum.repos.d/cfengine-community.repo"
        end

        if @yum_repo_url == UNSET_VALUE
          @yum_repo_url = "http://cfengine.com/pub/yum/"
        end
      end

      def validate(machine)
        errors = []

        valid_modes = [:bootstrap, :singlerun]
        errors << I18n.t("vagrant.cfengine_config.invalid_mode") if !valid_modes.include?(@mode)

        if @mode == :bootstrap
          errors << I18n.t("vagrant.cfengine_config.policy_server_address") if !@policy_server_address
        end

        { "CFEngine" => errors }
      end
    end
  end
end