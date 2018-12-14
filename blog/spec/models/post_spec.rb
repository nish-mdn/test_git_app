require 'rails_helper'
require 'rspec/expectations'

describe "Post class should be there" do
  it do
  post = Post.new
  expect(post.nil?).to be_falsey
  end
end

describe "Comment class should be there" do
  it do 
  comment = Comment.new
  expect(comment.nil?).to be_falsey
  end
end

describe "Image class should be there" do
  it do 
  image = Image.new
  expect(image.nil?).to be_falsey
  end
end