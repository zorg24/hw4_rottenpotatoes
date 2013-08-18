require 'spec_helper'

describe MoviesController do
  describe 'movies with same directors' do
    it 'should call same director' do
      Movie.create!(title: 'test', director: 'test_director') 
      controller.should_receive(:same_director)
      get 'same_director', id: 1   
    end  
    it 'should render same director view' do
      res = [mock('test_movie')]
      Movie.create!(title: 'test', director: 'test_director')
      Movie.stub(:find_all_by_director).and_return(res)
      get 'same_director', id: 1
      response.should render_template('same_director')
    end
    it 'should have access to movies_same_director in the view' do
      res = [mock('test_movie')]
      Movie.create!(title: 'test', director: 'test_director')
      Movie.stub(:find_all_by_director).and_return(res)
      get 'same_director', id: 1
      assigns(:movies_same_director).should == res
    end
  end

  describe 'show movies controller' do
    it 'should sort title for selected ratings' do
      get 'index', ratings: 'PG', sort: 'title'
    end
    it 'should sort date for selected ratings' do
      get 'index', ratings: 'PG', sort: 'release_date'
    end
    it 'should other params than session' do
      get 'index', ratings: 'G'
    end
    it 'should empty params use session' do
      get 'index', {}
    end
    it 'should change the title of a movie' do
      Movie.create!(title: 'test', id: 1)
      put :update, id: 1, movie: {:title => 'new_title'}
    end
    it 'should delete movie' do
      Movie.create(:title => 'test', :director => 'test_director', :id => 1)
      delete :destroy, {:id => 1}
      Movie.count.should == 0
    end
    it 'controller should show movie' do 
      Movie.create(:title => 'test', :director => 'test_director', :id => 1)
      get 'show', {:id=>1}
    end
    it 'should check if directors' do
      Movie.create(:title => 'test', :director => 'test_director', :id => 1)
      get :same_director, {:id => 1}
      response.should redirect_to(movies_path)
    end
  end
end