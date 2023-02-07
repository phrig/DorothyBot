FROM public.ecr.aws/lambda/ruby:2.7
RUN yum install -y gcc-c++ make
# Copy dependency management file
COPY Gemfile ${LAMBDA_TASK_ROOT}

# Install dependencies under LAMBDA_TASK_ROOT
ENV GEM_HOME=${LAMBDA_TASK_ROOT}
RUN bundle install

# Copy function code
COPY app.rb ${LAMBDA_TASK_ROOT}
COPY toot.rb ${LAMBDA_TASK_ROOT}
COPY get_quotes.rb ${LAMBDA_TASK_ROOT}


# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.lambda_handler"]"
