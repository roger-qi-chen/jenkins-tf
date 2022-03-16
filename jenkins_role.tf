resource "aws_iam_role" "jenkins" {
  name = "jenkins_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "jenkins_policy" {
  name = "jenkins_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
        Sid      = "VisualEditor2"
      },
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = "arn:aws:ssm:*:245866473499:parameter/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "jenkins_attach" {
  name = "jenkins_attachment"
  #   users      = [aws_iam_user.user.name]
  roles = [aws_iam_role.jenkins.name]
  #   groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.jenkins_policy.arn
}