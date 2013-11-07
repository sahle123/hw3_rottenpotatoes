# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  
      Movie.create!(movie)
  
  end
  # The flunk method unsures an error occurs with a message.
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  
  regexp = /#{e1}.*#{e2}/m # e1, any number of characters, e2, match across new lines. 
  page.body.should =~ regexp # This was taken directly from page 237 in SAAS book.

  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |rating| # parse rating_list and remove all whitespaces and ,
    if(!uncheck)
        steps %Q{ When I check "ratings[#{rating}]" }
    else
        steps %Q{ When I uncheck "ratings[#{rating}]" }
    end
  end
  #flunk "Unimplemented"
end

# Implementation for Then conjunction
Then /I should ( not)? see the following: (.*)/ do |nary, movie_list|

  movie_list.split(%r{.\s*}).each do |movies|
    if(nary)
      steps %Q{Then I should not see "#{movies}"}
    else
      if(movies == "none")
        rows = page.all('table#movies tbody tr').count
        rows.should == 0
      elsif(movies == "all")
        rows = page.all('table#movies tbody tr').count
        rows.should == Movie.all.size()
      else
        steps %Q{ Then I should see "#{movies}"}
      end
    end
  end

end