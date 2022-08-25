﻿using System;
using System.Net;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using SampleProject.Application.Customers;
using SampleProject.Application.Customers.GetCustomerDetails;
using SampleProject.Application.Customers.RegisterCustomer;

namespace SampleProject.API.Customers
{
    [Route("api/customers")]
    [ApiController]
    public class CustomersController : Controller
    {
        private readonly IMediator _mediator;

        public CustomersController(IMediator mediator)
        {
            this._mediator = mediator;
        }

        /// <summary>
        /// Register customer.
        /// </summary>
        
        
        [Route("")]
        [HttpPost]
        [ProducesResponseType(typeof(CustomerDto), (int)HttpStatusCode.Created)]
        public async Task<IActionResult> RegisterCustomer([FromBody]RegisterCustomerRequest request)
        {
           var customer = await _mediator.Send(new RegisterCustomerCommand(request.Email, request.Name));

           return Created(string.Empty, customer);
        }


        
        [HttpGet]      
        public async Task <IActionResult> GetSpecificCustomer(Guid id)
        {
            return Ok(id);
        }

        [HttpGet]
        [ProducesResponseType(typeof(CustomerDto), (int)HttpStatusCode.OK)]

        public async Task <IActionResult> GetCustomer()
         {
            
            return Ok(new CustomerDto { Id = Guid.NewGuid()});
         }
    }
}
