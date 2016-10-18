require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_homebrew" do
  RECIPES       = %w(homebrew homebrew::install_formulas homebrew::install_casks).freeze
  CASK_COMMANDS = { brew_uninstall_cask: 'brew uninstall --force brew-cask',
                    brew_cleanup:        'brew cleanup',
                    brew_cask_cleanup:   'brew cask cleanup' }.freeze

  let(:user) { 'jduggan' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal[COOKBOOK_NAME]['user'] = user
    end.converge(described_recipe)
  end

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    # Unsure of why this call causes failing specs... Removing to stub recipes individually.
    # RECIPES.each { |recipe| allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe) }
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('homebrew')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('homebrew::install_formulas')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('homebrew::install_casks')
  end

  describe 'Included Recipes:' do
    RECIPES.each do |recipe|
      it "includes #{recipe}" do
        expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)

        chef_run
      end
    end
  end

  describe 'Directories:' do
    it 'creates /usr/local' do
      expect(chef_run).to create_directory('/usr/local').with(owner: user, group: 'admin', mode: '0755')
    end
  end

  describe 'Execute Blocks:' do
    it "executes 'brew prune'" do
      expect(chef_run).to run_execute('brew prune').with(user: user, command: 'brew prune')
    end

    context 'homebrew cask cache dir does not exist' do
      before(:each) { allow(Dir).to receive(:exist?).and_return(false) }

      CASK_COMMANDS.each_pair do |k, v|
        it "executes #{k}" do
          expect(chef_run).to run_execute(k.to_s).with(user: user, command: v)
        end
      end
    end

    context 'homebrew cask cache dir exists' do
      before(:each) { allow(Dir).to receive(:exist?).and_return(true) }

      CASK_COMMANDS.each_pair do |k, _v|
        it "executes #{k}" do
          expect(chef_run).to_not run_execute(k.to_s)
        end
      end
    end
  end
end
