//
//  MovieFinderTests.swift
//  MovieFinderTests
//
//  Created by Çağrı Demir on 9.04.2022.
//

import XCTest
@testable import MovieFinder

class MovieFinderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testData() throws {
        let id = "tt1201607"
        var movies: [Movie]?
        var moviesList = [Movie]()
        var movies2Times: [Movie]?
        var movie: Movie?
        let query = "harry"
        
        let moviesExp = expectation(description: "movies")
        let moviesExp2 = expectation(description: "movies 2")
        let movieExp = expectation(description: "movie")
        
        getMovies(query: query, page: 1) { [weak self] response in
            guard let self = self else { return }
            if let results = response.movies {
                moviesList.append(contentsOf: results)
                movies = moviesList
                movies2Times = moviesList
                moviesExp.fulfill()
                self.getMovies(query: query,page: 2) { response in
                    if let results = response.movies {
                        moviesList.append(contentsOf: results)
                        movies2Times = moviesList
                        moviesExp2.fulfill()
                        getMovie()
                    }
                }
            }
        }
        
        func getMovie() {
            MovieRepo.getMovie(id: id) { response in
                movie = response
                movieExp.fulfill()
            } failure: { error in
                print(error.rawValue)
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            print(error.debugDescription)
        }
        
        XCTAssertEqual(movies?.count ?? 0, 10, "Count of movies must be 10.")
        XCTAssertLessThanOrEqual(movies2Times?.count ?? 0, 20, "Count of total of 2 pages of movies must be 20.")
        XCTAssertEqual(movie?.imdbID ?? "", id, "Movie id must be tt1201607")
    }
    
    func getMovies(query: String, page: Int, success: @escaping(_ response: MovieModel) -> Void) {
        MovieRepo.getMovies(urlPrefix: query, page: page) { response in
            success(response)
        } failure: { error in
            print(error.rawValue)
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
