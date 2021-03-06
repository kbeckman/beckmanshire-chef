require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_homebrew" do
  RECIPES       = %w[homebrew homebrew::install_formulas homebrew::install_casks].freeze
  EXECUTE_CMDS  = { brew_prune:         'brew prune',
                    brew_cleanup:       'brew cleanup',
                    brew_cask_cleanup:  'brew cask cleanup' }.freeze

  let(:user) { 'jduggan' }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(CHEF_SPEC_OPTS) do |node|
      node.normal[COOKBOOK_NAME]['user'] = user
    end.converge(described_recipe)
  end

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    RECIPES.each { |recipe| allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe) }
  end

  describe 'Included Recipes:' do
    RECIPES.each do |recipe|
      it "includes '#{recipe}'" do
        expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)

        chef_run
      end
    end
  end

  describe 'Execute Blocks:' do
    EXECUTE_CMDS.each_pair do |k, v|
      it "executes '#{k}'" do
        expect(chef_run).to run_execute(k.to_s).with(user: user, command: v)
      end
    end
  end
end
