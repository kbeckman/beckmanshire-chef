require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_default" do
  let(:valid_user) { 'rflair' }
  let(:valid_castle_name) { 'limousine_ridin' }
  let(:valid_github_repo) { 'git://github.com/rflair/castle' }
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
            node.normal[COOKBOOK_NAME]['user']                    = nil
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = valid_castle_name
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = valid_github_repo
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end

      it "raises an exeption when node['#{COOKBOOK_NAME}']['user'] is empty" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user']                    = ''
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = valid_castle_name
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = valid_github_repo
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end
    end

    context "node['#{COOKBOOK_NAME}']['homesick']['castle_name]'" do
      let(:error_msg) { "node['#{COOKBOOK_NAME}']['homesick']['castle_name'] must be set!" }

      it "raises an exeption when node['#{COOKBOOK_NAME}']['homesick']['castle_name'] is nil" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user']                    = valid_user
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = nil
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = valid_github_repo
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end

      it "raises an exeption when node['#{COOKBOOK_NAME}']['homesick']['castle_name'] is empty" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user']                    = valid_user
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = ''
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = valid_github_repo
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end
    end

    context "node['#{COOKBOOK_NAME}']['homesick']['github_repo]'" do
      let(:error_msg) { "node['#{COOKBOOK_NAME}']['homesick']['github_repo'] must be set!" }

      it "raises an exeption when node['#{COOKBOOK_NAME}']['homesick']['github_repo'] is nil" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user']                    = valid_user
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = valid_castle_name
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = nil
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end

      it "raises an exeption when node['#{COOKBOOK_NAME}']['homesick']['github_repo'] is empty" do
        chef_run = lambda do
          ChefSpec::SoloRunner.new do |node|
            node.normal[COOKBOOK_NAME]['user']                    = valid_user
            node.normal[COOKBOOK_NAME]['homesick']['castle_name'] = valid_castle_name
            node.normal[COOKBOOK_NAME]['homesick']['github_repo'] = ''
          end.converge(described_recipe)
        end

        expect { chef_run.call }.to raise_error(error_msg)
      end
    end
  end
end
