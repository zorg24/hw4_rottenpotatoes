# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(:title => movie['title'],
                  :rating => movie['rating'],
                  :release_date => movie['release_date'])
  end
end

When /I go to the edit page for "([^"]*)"/ do |movie|
  visit edit_movie_path(Movie.find_by_title movie)
end

When /I fill in "([^"]*) with "([^"]*)"/ do |name, value|
  fill_in name, :with => value
end

Then /the director of "([^"]*)" should be "([^"]*)"/ do |movie, director|
  Movie.find_by_title(movie).director.should == director
end

Given /I am on the details page for "([^"]*)"/ do |movie|
  visit movie_path(Movie.find_by_title movie)
end

Then /I should be on the Similar Movies page for "([^"]*)"/ do |movie_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    pat = same_director_path(Movie.find_by_title(movie_name).id)
    current_path.should == pat
  else
    assert_equal pat, current_path
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "([^"]*)" before "([^"]*)"/ do |e1, e2|
  assert page.body =~ /#{e1}.*#{e2}/m
end

Then /I should (not )?see the following movies: (.*)/ do |n, movie_list|
  movie_list = movie_list.split(", ")
  movie_list.each do |mov|
    if n
      page.should have_no_content(mov)
    else
      page.should have_content(mov)
    end
  end
end

When /I press on the homepage "([^"]*)"/ do |button|
  click_button("ratings_submit") if button == "Refresh"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rat|
    
    if uncheck
      uncheck("ratings_" + rat)
    else
      check("ratings_" + rat)
    end
  end
end