require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::mac_os" do
  RECIPES = ["#{COOKBOOK_NAME}::_default", "#{COOKBOOK_NAME}::_homebrew", 'rvm::user',
             "#{COOKBOOK_NAME}::_oh_my_zsh", "#{COOKBOOK_NAME}::_homesick"].freeze

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal[COOKBOOK_NAME]['user'] = 'jduggan'
    end.converge(described_recipe)
  end

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    RECIPES.each { |recipe| allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe) }
  end

  describe 'Included Recipes:' do
    RECIPES.each do |recipe|
      it "includes #{recipe}" do
        expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)

        chef_run
      end
    end
  end

  describe 'reboot_system' do
    it 'requests a reboot' do
      expect(chef_run).to request_reboot('reboot_system').with(reason: 'End of chef-client run...', delay_mins: 0)
    end
  end
end
