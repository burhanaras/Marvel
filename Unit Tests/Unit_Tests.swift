//
//  Unit_Tests.swift
//  Unit Tests
//
//  Created by Burhan Aras on 29.08.2021.
//

import XCTest
import Combine

class Unit_Tests: XCTestCase {
    
//    MARK: - Mapping Tests for model and DTO classes.
    func test_mapping_from_marvelDTO_to_Marvel_model(){
        // GIVEN: that we have a marvelDTO object
        let marvelDTO = MarvelDTO(id: 0, name: "Marvel 0", description: "I'm Iron Man!", thumbnail: thumbnail)
        
        // WHEN: marvelDTO is converted to marvel
        let marvel = Marvel.fromDTO(dto: marvelDTO)
        
        // THEN: All the fields must be same
        XCTAssertEqual(marvel.id, String(marvelDTO.id))
        XCTAssertEqual(marvel.title, marvelDTO.name)
        XCTAssertEqual(marvel.description, marvelDTO.description)
    }
    
    
//    MARK: - MarvelListViewModel Tests
    func test_MarvelListViewModel_returns_correct_data() throws {
        // GIVEN: that we have a TestNetworkLayer that returns 5 characters
        let networkLayer = TestNetworkLayer(charactersResponse: testCharactersResponse, comicsResponse: testComicsResponse)
        
        // WHEN: MarvelListViewModel is initialized
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        
        // THEN: ViewModel's data should be same
        XCTAssertEqual(try? viewModel.data?.get().count, testCharactersResponse.data.results.count)
    }

    func test_MarvelListViewModel_returns_error_when_network_layer_fails() {
        // GIVEN: that we have a NetworkLayer that fails
        let networkLayer = TestFailingNetworkLayer()
        
        // WHEN: MarvelListViewModel is initialized
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        
        // THEN: ViewModel's data should be .failure()
        XCTAssertEqual(viewModel.data, Result<[Marvel], CommonError>.failure(.networkError))
    }
    
    func test_paging_should_work_correctly(){
        // GIVEN: that we have a network layer and a ViewModel
        let pagingCount = 30
        let charactersResponse = CharactersResponse(code: 200, data: CharactersDataResponse(offset: 0, limit: pagingCount, total: 125, results: DummyData.marvelDTOs(count: pagingCount)))
        let networkLayer = TestNetworkLayer(charactersResponse: charactersResponse, comicsResponse: testComicsResponse)
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        XCTAssertEqual(try viewModel.data?.get().count, pagingCount)
        
        // WHEN: loadNextPage() is triggered
        viewModel.loadNextPage()
        
        // THEN: viewModel's data should contain second page also.
        XCTAssertEqual(try viewModel.data?.get().count, pagingCount * 2)
    }
    
    func test_paging_should_not_try_to_fetch_more_if_no_more_page_is_available(){
        // GIVEN: that we have a network layer and a ViewModel
        let pagingCount = 30
        let charactersResponse = CharactersResponse(code: 200, data: CharactersDataResponse(offset: 0, limit: pagingCount, total: 45, results: DummyData.marvelDTOs(count: pagingCount)))
        let networkLayer = TestNetworkLayer(charactersResponse: charactersResponse, comicsResponse: testComicsResponse)
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        XCTAssertEqual(try viewModel.data?.get().count, pagingCount)
        
        // WHEN: loadNextPage() is triggered twice
        viewModel.loadNextPage()
        viewModel.loadNextPage()
        
        // THEN: viewModel's data should contain the first and second page. NOT the third one
        XCTAssertEqual(try viewModel.data?.get().count, pagingCount * 2)
    }
    
//    MARK: - MarvelDetail Tests
    func test_MarvelDetailViewModel_returns_correct_data() throws {
        // GIVEN: that we have a MarvelDTO and a NetworkLayer that returns that DTO for detail
        let networkLayer = TestNetworkLayer(charactersResponse: testCharactersResponse, comicsResponse: testComicsResponse)
        
        // WHEN: MarvelDetailViewModel's loadProductDetail() is called
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        viewModel.loadProductDetail()
        
        // THEN: ViewModel's data should be same
        XCTAssertEqual(try viewModel.data?.get().id, String(testMarvelDTO0.id))
        XCTAssertEqual(try viewModel.data?.get().title, testMarvelDTO0.name)
        XCTAssertEqual(try viewModel.data?.get().description, testMarvelDTO0.description)
        XCTAssertEqual(try viewModel.data?.get().image, testMarvelDTO0.thumbnail.completeURL)

    }
    
    func test_MarvelDetailViewModel_returns_correct_data_for_Comics() {
        // GIVEN: that we have a ViewModel and a NetworkLayer that returns Comics objects
        let networkLayer = TestNetworkLayer(charactersResponse: testCharactersResponse, comicsResponse: testComicsResponse)
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        
        // WHEN: MarvelDetailViewModel's loadProductDetail() is called
        viewModel.loadProductDetail()
        
        // THEN: ViewModel's comics data should be loaded
        XCTAssertEqual(viewModel.comics.count, testComicsResponse.data.results.count)
        XCTAssertEqual(viewModel.comics[0].id, testComicsResponse.data.results[0].id)
        XCTAssertEqual(viewModel.comics[0].title, testComicsResponse.data.results[0].title)
        XCTAssertEqual(viewModel.comics[0].image, testComicsResponse.data.results[0].thumbnail.completeURL)
    }

}


// MARK: - NetworkLayer's to be used in tests. One returns data, other one fails.
class TestNetworkLayer: INetworkLayer {
    private var charactersResponse: CharactersResponse
    private var comicsResponse: ComicsResponse
    
    init(charactersResponse: CharactersResponse, comicsResponse: ComicsResponse) {
        self.charactersResponse = charactersResponse
        self.comicsResponse = comicsResponse
    }
    
    var baseURL: NSString { return "" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.success(charactersResponse))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.success(comicsResponse))
            .eraseToAnyPublisher()
    }

}

class TestFailingNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}


// MARK: - Dummy test datas to use in test methods
let thumbnail = ThumbnailDTO(path: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg")
let testMarvelDTO0 = MarvelDTO(id: 0, name: "Marvel 0", description: "I'm Iron Man!", thumbnail: thumbnail)
let testMarvelDTO1 = MarvelDTO(id: 1, name: "Marvel 1", description: "I'm Iron Man!", thumbnail: thumbnail)
let testMarvelDTO2 = MarvelDTO(id: 2, name: "Marvel 2", description: "I'm Iron Man!", thumbnail: thumbnail)
let testMarvelDTO3 = MarvelDTO(id: 3, name: "Marvel 3", description: "I'm Iron Man!", thumbnail: thumbnail)
let testMarvelDTO4 = MarvelDTO(id: 4, name: "Marvel 4", description: "I'm Iron Man!", thumbnail: thumbnail)

let testCharacters = [testMarvelDTO0, testMarvelDTO1, testMarvelDTO2, testMarvelDTO3, testMarvelDTO4]
let testCharactersResponse = CharactersResponse(code: 200, data: CharactersDataResponse(offset: 0, limit: 5, total: 30, results: testCharacters))

let testComicsDTO0 = ComicDTO(id: 0, title: "Comics 0", thumbnail: thumbnail)
let testComicsArray = [testComicsDTO0]
let testComicsResponse = ComicsResponse(code: 200, data: ComicsData(offset: 0, limit: 10, total: 30, results: testComicsArray))
