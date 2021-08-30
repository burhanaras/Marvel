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
    func test_mapping_from_productDTO_to_product_model(){
        // GIVEN: that we have a productDTO object
        let productDTO = ProductDTO(productid: 0, title: "Product0", moneyprice: "1 USD", productgrouptype: 10)
        
        // WHEN: productDTO is converted to product
        let product = Product.fromDTO(dto: productDTO)
        
        // THEN: All the fields must be same
        XCTAssertEqual(product.id, String(productDTO.productid))
        XCTAssertEqual(product.title, productDTO.title)
        XCTAssertEqual(product.price, productDTO.moneyprice)
        XCTAssertEqual(product.productGroupType, String(productDTO.productgrouptype!))
    }
    
    
//    MARK: - ProductListViewModel Tests
    func test_ProductListViewModel_returns_correct_data() throws {
        // GIVEN: that we have a TestNetworkLayer that returns 5 products
        let networkLayer = TestNetworkLayer(response: dummyProductsResponse, productDTO: testProductDTO0)
        
        // WHEN: ProductListViewModel is initialized
        let viewModel = ProductListViewModel(networkLayer: networkLayer)
        
        // THEN: ViewModel's data should be same
        XCTAssertEqual(try? viewModel.data?.get().count, dummyProductsResponse.items.count)
    }

    func test_ProductListViewModel_returns_error_when_network_layer_fails() {
        // GIVEN: that we have a NetworkLayer that fails
        let networkLayer = TestFailingNetworkLayer()
        
        // WHEN: ProductListViewModel is initialized
        let viewModel = ProductListViewModel(networkLayer: networkLayer)
        
        // THEN: ViewModel's data should be .failure()
        XCTAssertEqual(viewModel.data, Result<[Product], CommonError>.failure(.networkError))
    }
    
    func test_paging_should_work_correctly(){
        // GIVEN: that we have a network layer and a ViewModel
        let productsResponse = ProductsResponse(totalcount: 25, items: DummyData.productDTOs(count: 20))
        let networkLayer = TestNetworkLayer(response: productsResponse, productDTO: testProductDTO0)
        let viewModel = ProductListViewModel(networkLayer: networkLayer)
        XCTAssertEqual(try viewModel.data?.get().count, 20)
        
        // WHEN: loadNextPage() is triggered
        viewModel.loadNextPage()
        
        // THEN: viewModel's data should contain second page also.
        XCTAssertEqual(try viewModel.data?.get().count, 40)
    }
    
    func test_paging_should_not_try_to_fetch_more_if_no_more_page_is_available(){
        // GIVEN: that we have a network layer and a ViewModel
        let productsResponse = ProductsResponse(totalcount: 25, items: DummyData.productDTOs(count: 20))
        let networkLayer = TestNetworkLayer(response: productsResponse, productDTO: testProductDTO0)
        let viewModel = ProductListViewModel(networkLayer: networkLayer)
        XCTAssertEqual(try viewModel.data?.get().count, 20)
        
        // WHEN: loadNextPage() is triggered twice
        viewModel.loadNextPage()
        viewModel.loadNextPage()
        
        // THEN: viewModel's data should contain the first and second page. NOT the third one
        XCTAssertEqual(try viewModel.data?.get().count, 40)
    }
    
//    MARK: - ProductDetail Tests
    func test_ProductDetailViewModel_returns_correct_data() throws {
        // GIVEN: that we have a ProductDTO and a NetworkLayer that returns that DTO for detail
        let productDTO = ProductDTO(productid: 1453, title: "My lovely product", moneyprice: "1 USD", productgrouptype: 10)
        let networkLayer = TestNetworkLayer(response: dummyProductsResponse, productDTO: productDTO)
        
        // WHEN: ProductDetailviewModel is initialized with a productID
        let viewModel = ProductDetailViewModel(networkLayer: networkLayer, productId: String(productDTO.productid))
        
        // THEN: ViewModel's data should be same
        XCTAssertEqual(try viewModel.data?.get().id, String(productDTO.productid))
        XCTAssertEqual(try viewModel.data?.get().title, productDTO.title)
        XCTAssertEqual(try viewModel.data?.get().price, productDTO.moneyprice)
        XCTAssertEqual(try viewModel.data?.get().productGroupType, String(productDTO.productgrouptype!))
    }
    
    func test_ProductDetailViewModel_returns_error_when_network_layer_fails() {
        // GIVEN: that we have a NetworkLayer that fails
        let networkLayer = TestFailingNetworkLayer()
        
        // WHEN: ProductListViewModel is initialized
        let viewModel = ProductDetailViewModel(networkLayer: networkLayer, productId: "123")
        
        // THEN: ViewModel's data should be .failure()
        XCTAssertEqual(viewModel.data, Result<Product, CommonError>.failure(.networkError))
    }

}


// MARK: - NetworkLayer's to be used in tests. One returns data, other one fails.
class TestNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "" as NSString }
    
    private var response: ProductsResponse
    private var productDTO: ProductDTO
    
    init(response: ProductsResponse, productDTO: ProductDTO) {
        self.response = response
        self.productDTO = productDTO
    }
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.success(response))
            .eraseToAnyPublisher()
    }
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        return Result<ProductDTO, RequestError>
            .Publisher(.success(productDTO))
            .eraseToAnyPublisher()
    }
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.success(testProductImageResponse))
            .eraseToAnyPublisher()
    }
}

class TestFailingNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "" as NSString }
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        return Result<ProductDTO, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}


// MARK: - Dummy test datas to use in test methods
let testProductDTO0 = ProductDTO(productid: 0, title: "Product0", moneyprice: "1 USD", productgrouptype: 10)
let testProductDTO1 = ProductDTO(productid: 1, title: "Product1", moneyprice: "2 USD")
let testProductDTO2 = ProductDTO(productid: 2, title: "Product2", moneyprice: "3 USD")
let testProductDTO3 = ProductDTO(productid: 3, title: "Product3", moneyprice: "4 USD")
let testProductDTO4 = ProductDTO(productid: 4, title: "Product4", moneyprice: "5 USD")

let testProducts = [testProductDTO0, testProductDTO1, testProductDTO2, testProductDTO3, testProductDTO4]
let testProductsResponse = ProductsResponse(totalcount: 12, items: testProducts)
let testProductImageResponse = ProductImagesResponse(totalcount: 1, items: [ProductImageDTO(resourceid: "123.jpg")])
