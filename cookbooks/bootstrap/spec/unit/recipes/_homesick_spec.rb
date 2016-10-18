require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_homesick" do
  let(:user) { 'rflair' }
  let(:castle_name) { 'limousine_ridin' }
  let(:github_repo) { 'git:://github.com/rflair/castle' }
  let(:addl_symlinks) { [{ 'source' => 'test_file', 'link' => 'linked_file' }] }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal[COOKBOOK_NAME]['user']                            = user
      node.normal[COOKBOOK_NAME]['homesick']['castle_name']         = castle_name
      node.normal[COOKBOOK_NAME]['homesick']['github_repo']         = github_repo
      node.normal[COOKBOOK_NAME]['homesick']['additional_symlinks'] = addl_symlinks
    end.converge(described_recipe)
  end

  describe 'execute[clone_homesick_castle]:' do
    context 'castle dir does not exist' do
      before(:each) do
        allow(Dir).to receive(:exist?).with("/Users/#{user}/.homesick/repos/#{castle_name}").and_return(false)
      end

      it "executes 'clone_homesick_castle'" do
        expect(chef_run).to run_execute('clone_homesick_castle').with(command: "homesick clone #{github_repo}")
      end
    end

    context 'castle dir already exists' do
      before(:each) do
        allow(Dir).to receive(:exist?).with("/Users/#{user}/.homesick/repos/#{castle_name}").and_return(true)
      end
      it "does not execute 'clone_homesick_repo'" do
        expect(chef_run).to_not run_execute('clone_homesick_repo')
      end
    end
  end

  describe "execute 'symlink_homesick_castle':" do
    let(:subject) { chef_run.execute('symlink_homesick_castle') }

    it 'is configured but does nothing until notified' do
      expect(subject).to              do_nothing
      expect(subject.user).to eq      user
      expect(subject.command).to eq   "homesick link #{castle_name} --force"
    end

    it 'subscribes to execute[homesick_clone_repo]' do
      expect(subject).to subscribe_to('execute[clone_homesick_castle]').on(:run).immediately
    end
  end

  describe "execute 'symlink linked_file':" do
    let(:subject) { chef_run.execute('symlink linked_file') }

    it 'is configured but does nothing until notified' do
      expect(subject).to              do_nothing
      expect(subject.user).to eq      user
      expect(subject.command).to eq   "ln -sfv #{addl_symlinks[0]['source']} #{addl_symlinks[0]['link']}"
    end

    it 'subscribes to execute[symlink_homesick_castle]' do
      expect(subject).to subscribe_to('execute[symlink_homesick_castle]').on(:run).immediately
    end
  end
end
