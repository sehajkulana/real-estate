# Real Estate

## Property-image storage

Development stores property images locally through Active Storage. Production
stores them in Amazon S3. Configure these production environment variables with
an IAM user or role that can read and write to the chosen bucket:

```bash
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=ap-south-1
AWS_S3_BUCKET=your-bucket-name
```

Then install dependencies and run migrations:

```bash
bundle install
bin/rails db:migrate
```
