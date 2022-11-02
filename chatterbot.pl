# �l�H���\2020�T���v���v���O����
# �v���_�N�V�������[���iif-then���[���j���x�[�X
# �������̃t�@�C����TSV�`���i�^�u��؂�̃e�L�X�g�t�@�C���j
# �@�����f�[�^��Excel�ŊǗ�
# �@��Excel�̓��e���e�L�X�g�G�f�B�^�ɃR�s�[���y�[�X�g����ƁC��̋�؂肪�^�u�ɂȂ�i�t�������j
# �����R�[�h�FShift-jis

use strict;
use Encode;


# �l�H���\�̖��O
my $chatterbot_name = "test";

# �l�H���\�̔��b�p
my $chatterbots_utterance;

# ���[�U�̖��O���擾����
my $user_name;
&Get_User_Name();

# �l�H���\�̔��b�p
my $users_utterance;



print "--- $user_name �� $chatterbot_name �̑Θb�J�n ---\n";

# �l�H���\�̔��b��I������i�Θb�̊J�n���p�j
Select_Catterbot_Utterence1();

# �l�H���\�̔��b���o��
print "$chatterbot_name > $chatterbots_utterance\n";

# �l�H���\�̔��b�ɑΉ����鍇���������Đ�����
&Play_Synthetic_Speech();



# �������[�v
while(1){
	# ���[�U�̔��b�i���b�Z�[�W�j���擾
	&Get_Users_Utterance();

	# �Θb�̏I���̃`�F�b�N
	if( &Chec_End_of_Dialogue() ){
		# �l�H���\�̔��b���o��
		print "$chatterbot_name > $chatterbots_utterance\n";

		# �l�H���\�̔��b�ɑΉ����鍇���������Đ�����
		&Play_Synthetic_Speech();

		print "--- $user_name �� $chatterbot_name �̑Θb�I�� ---\n";
		last;
	}

	# �l�H���\�̔��b��I������i�Θb���p�j
	Select_Catterbot_Utterence2();

	# �l�H���\�̔��b���o��
	print "$chatterbot_name > $chatterbots_utterance\n";

	# �l�H���\�̔��b�ɑΉ����鍇���������Đ�����
	&Play_Synthetic_Speech();

}







exit;





#################### ��������T�u���[�`�� ####################


########################################
# @list����$str���܂܂�Ă���΁C���̃C���f�b�N�X��Ԃ��D
# �����łȂ���΁C-1��Ԃ��D
sub include{
	my ($str, @list) = @_;

	for( my $i=0; $i<@list; $i++){
		if( $str eq $list[$i]){
			return $i;
		}
	}
	return -1;
}



########################################
# ���[�U�̖��O���擾����
# ���炩�̓��͂�����܂ŕW�����͂��J��Ԃ�
sub Get_User_Name{
	my $stdin;
	while(1){
		print "���Ȃ��̖��O����͂��Ă������� > ";
		$stdin = <STDIN>;
		$stdin =~ s/\n|\r\n|\r//;
		if( $stdin ne "" ){
			last;
		}
	}
	$user_name = $stdin;
}



########################################
# �l�H���\�̔��b��I������i�Θb�̊J�n���p�j
# �v���_�N�V�������[���iif-then���[���j���x�[�X
sub Select_Catterbot_Utterence1{
	my $line;
	my @list;

	# �����̓��e���i�[����
	# @candidate��@weight�̃C���f�b�N�X�͑Ή�����
	# �l�H���\�̔��b�̌��
	my @candidate;
	# �d�݂̗ݐ�
	my @weight;
	# �d�݂̍��v
	my $total = 0;

	# �����̓ǂݍ���
	my $i = 0;


	open(IN, "dic1.txt") or die $!;
	
	
	
	flock(IN, 1);
	
	
	while(<IN>){
		# �擪����1�s�����Ԃ�$line�Ɋi�[
		$line = $_;

		# �擪�Ɂu#�v���t���Ă���R�����g�Ȃ̂ŁC�ȍ~�̃��[�v���̏������X�L�b�v����
		if( $line =~ /^#/ ){
			next;
		}

		# �����̉��s�R�[�h���폜
		$line =~ s/\n|\r\n|\r//;

		# �^�u�i\t�j�ŕ���
		@list = split("\t", $line);

		# �d�݂̍��v���v�Z
		$total += $list[1];

		$candidate[$i] = $list[0];
		$weight[$i] = $total;
		$i++;
	}
	close(IN);


	# �o�͂��锭�b��I������
	# ���[���b�g�����őI��
	# 0�`$total�܂ł̗����𔭐�
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
}



########################################
# �l�H���\�̔��b�ɑΉ����鍇�������̃t�@�C���p�X���擾����
# �l�H���\�̔��b�́C$chatterbots_utterance�ɕێ�����Ă���
sub Get_Synthesized_Speech_File{
	my $line;
	my @list;

	# �l�H���\�̔��b�̍��������i�t�@�C���p�X�j
	my $path = "./voice_data/";

	# �����t�@�C�����X�g�̓ǂݍ���
	open(IN, "./voice_data/filelist.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# �擪����1�s�����Ԃ�$line�Ɋi�[
		$line = $_;

		# �擪�Ɂu#�v���t���Ă���R�����g�Ȃ̂ŁC�ȍ~�̃��[�v���̏������X�L�b�v����
		if( $line =~ /^#/ ){
			next;
		}

		# �����̉��s�R�[�h���폜
		$line =~ s/\n|\r\n|\r//;

		# �^�u�i\t�j�ŕ���
		@list = split("\t", $line);

		if( $chatterbots_utterance eq $list[0]){
			$path .= $list[1];
			last;
		}
	}
	close(IN);
	return $path;
}



########################################
# �l�H���\�̔��b�ɑΉ����鍇���������Đ�����
sub Play_Synthetic_Speech(){
	# �l�H���\�̔��b�ɑΉ����鍇�������̃t�@�C���p�X���擾����
	# �l�H���\�̔��b�̍��������i�t�@�C���p�X�j
	my $synthesized_speech_file = Get_Synthesized_Speech_File();

	# �����t�@�C�������݂��Ȃ��ꍇ�C�Đ������Ȃ�
	unless( -f $synthesized_speech_file ){
		print "\t���Ή����鉹���t�@�C��������܂���D\n";
		return;
	}

	# �f�t�H���g�̃T�E���h�v���C���[���N�����āC�������Đ�
	# �o�b�N�O���E���h�ŋN�������܂܂ɂȂ��Ă��܂��̂Œ��ӂ���
	#system("cmd $synthesized_speech_file");
	# Windows�p
	system("start $synthesized_speech_file");
}



########################################
# ���[�U�̔��b�i���b�Z�[�W�j���擾
# �W�����͂̓��e��$users_utterance�Ɋi�[����
sub Get_Users_Utterance{
	print "$user_name > ";
	$users_utterance = <STDIN>;
	# �����̉��s�R�[�h���폜
	$users_utterance =~ s/\n|\r\n|\r//;
}



########################################
# �Θb�̏I���̃`�F�b�N
# �����ɑΘb�����I���̃L�[���[�h���o�^����Ă��邩�ǂ���
# �߂�l1�F�Θb���I���
# �߂�l0�F�Θb�𑱂���
sub Chec_End_of_Dialogue{
	my $line;
	my @list;

	# �����̓��e���i�[����
	# @candidate��@weight�̃C���f�b�N�X�͑Ή�����
	# �l�H���\�̔��b�̌��
	my @candidate;
	# �d�݂̗ݐ�
	my @weight;
	# �d�݂̍��v
	my $total = 0;

	# �����̓ǂݍ���
	my $i = 0;
	open(IN, "dic3.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# �擪����1�s�����Ԃ�$line�Ɋi�[
		$line = $_;

		# �擪�Ɂu#�v���t���Ă���R�����g�Ȃ̂ŁC�ȍ~�̃��[�v���̏������X�L�b�v����
		if( $line =~ /^#/ ){
			next;
		}

		# �����̉��s�R�[�h���폜
		$line =~ s/\n|\r\n|\r//;

		# �^�u�i\t�j�ŕ���
		@list = split("\t", $line);

		# UTF8�������������ɕϊ��i�J������UTF8�̂Ƃ��j
		# encode�i���ɖ߂��֐��j�͕s�v�i$list[0]�̎g�p�̓`�F�b�N�����Ȃ̂Łj
		my $tmp = decode('Shift_JIS', $list[0]);
		my $decoded_users_utterance = decode('Shift_JIS', $users_utterance);

		if( $users_utterance eq $list[0] ){ # ���S��v�i�������r���Z�qeq���g�p�j
		#if( index($decoded_users_utterance, $tmp) != -1){ # ������v�iindex�֐����g�p�j
			# �d�݂̍��v���v�Z
			$total += $list[2];

			$candidate[$i] = $list[1];
			$weight[$i] = $total;
			$i++;
		}
	}
	close(IN);

	# �Θb���I������L�[���[�h�����݂��Ȃ�
	# �ˏd�݂̍��v��0
	# �ˑΘb�𑱂���
	if( $total == 0 ){
		return 0;
	}

	# �o�͂��锭�b�i�Θb�I�����̔��b�j��I������
	# ���[���b�g�����őI��
	# 0�`$total�܂ł̗����𔭐�
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
	return 1;
}



########################################
# �l�H���\�̔��b��I������i�Θb���p�j
sub Select_Catterbot_Utterence2{
	my $line;
	my @list;

	# �����̓��e���i�[����
	# @candidate��@weight�̃C���f�b�N�X�͑Ή�����
	# �l�H���\�̔��b�̌��
	my @candidate;
	# �d�݂̗ݐ�
	my @weight;
	# �d�݂̍��v
	my $total = 0;

	# �����̓ǂݍ���
	my $i = 0;
	open(IN, "dic2.txt") or die $!;
	flock(IN, 1);
	while(<IN>){
		# �擪����1�s�����Ԃ�$line�Ɋi�[
		$line = $_;

		# �擪�Ɂu#�v���t���Ă���R�����g�Ȃ̂ŁC�ȍ~�̃��[�v���̏������X�L�b�v����
		if( $line =~ /^#/ ){
			next;
		}

		# �����̉��s�R�[�h���폜
		$line =~ s/\n|\r\n|\r//;

		# �^�u�i\t�j�ŕ���
		@list = split("\t", $line);

		# UTF8�������������ɕϊ��i�J������UTF8�̂Ƃ��j
		# encode�i���ɖ߂��֐��j�͕s�v�i$list[0]�̎g�p�̓`�F�b�N�����Ȃ̂Łj
		my $tmp = decode('Shift_JIS', $list[0]);
		my $decoded_users_utterance = decode('Shift_JIS', $users_utterance);

		if( $users_utterance eq $list[0] ){ # ���S��v�i�������r���Z�qeq���g�p�j
		#if( index($decoded_users_utterance, $tmp) != -1){ # ������v�iindex�֐����g�p�j
			# �d�݂̍��v���v�Z
			$total += $list[2];

			$candidate[$i] = $list[1];
			$weight[$i] = $total;
			$i++;
		}
	}
	close(IN);

	# ���[�U�����͂��ׂ��L�[���[�h���������ɑ��݂��Ȃ�
	# �ˏd�݂̍��v��0
	# �˃G���[���b�Z�[�W���o�͂��đΘb�𑱂���
	if( $total == 0 ){
		# �G���[���b�Z�[�W�̗�
		$chatterbots_utterance = "�ʂ̃��b�Z�[�W����͂��Ă��������D";
		return;
	}


	# �o�͂��锭�b�i�Θb�I�����̔��b�j��I������
	# ���[���b�g�����őI��
	# 0�`$total�܂ł̗����𔭐�
	my $rand = rand($total);
	for( $i=0; $i<@candidate; $i++){
		if( $rand < $weight[$i] ){
			# print "$candidate[$i]\t$weight[$i]\n";
			$chatterbots_utterance = $candidate[$i];
			last;
		}
	}
}




__END__
