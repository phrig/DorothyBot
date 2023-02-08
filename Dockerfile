FROM public.ecr.aws/lambda/ruby:2.7
# Install dependencies for nokogiri and other native extensions
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

# Must match configuration in lambda
CMD [ "app.lambda_handler"]"
