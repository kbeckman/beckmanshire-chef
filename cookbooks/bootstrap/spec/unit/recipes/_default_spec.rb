require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_default" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal[COOKBOOK_NAME]['user'] = 'jduggan'
    end.converge(descrbed_recipe)
  end

  describe 'Attribute Checks:' do
    context "node['#{COOKBOOK_NAME}']['user']" do
      let(:error_msg) { "node['#{COOKBOOK_NAME}']['user'] must be set!" }

      it "raises an exeption when node['#{COOKBOOK_NAME}']['user'] is nil" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user'] = nil
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end

      it "raises an exeption when node['#{COOKBOOK_NAME}']['user'] is empty" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user'] = ''
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end
    end
  end
end
